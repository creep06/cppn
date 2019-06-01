require 'net/http'
require 'uri'
require 'date'

class RecentProblem < ApplicationRecord
    belongs_to :user
    belongs_to :problem


    def RecentProblem.post_recent
        # plist = {user_id: {'size(problems)', 'point(sum)', 'problem': [recentproblem_id]}}
        plist = {}
        User.find_each do |u|
            uid = u.id
            pros = RecentProblem.where(user_id: uid)
            next if pros.empty?
            plist[uid] = {}
            plist[uid]['size'] = 0
            plist[uid]['point'] = 0
            plist[uid]['problem'] = []
            pros.each do |p|
                plist[uid]['size'] += 1
                plist[uid]['point'] += p.point
                plist[uid]['problem'].push(p.id)
            end
            # 問題は点数の降順に並べる
            plist[uid]['problem'].sort! do |pid1, pid2|
                pt1 = RecentProblem.find(pid1).point
                pt2 = RecentProblem.find(pid2).point
                pt2 <=> pt1
            end
        end
        return if plist.empty?
        # ユーザーは解いた問題数の降順に並べる
        plist = plist.sort do |(k1,v1), (k2,v2)|
            s1 = v1['size']
            s2 = v2['size']
            s2 <=> s1
        end

        post = {}
        post['attachments'] = []
        colors = ['#86AC41', '34675C', '7DA3A1']
        cnt = 0
        plist.each do |uid,p|
            hash2 = {}
            hash2['title'] = "#{User.find(uid).name} solved #{p['size']} problem" + (p['size']==1 ? ', ' : 's, ') + "scoring #{p['point']} points!"
            hash2['value'] = ''
            if p['size'] > 10
                hash2['value'] = 'This margin is too narrow to contain.'
            else
                p['problem'].each do |pid|
                    pro = RecentProblem.find(pid)
                    hash2['value'] += "#{pro.point}pts - #{pro.name}\n#{pro.url}\n"
                end
            end
            hash1 = {}
            hash1['color'] = colors[cnt%3]
            hash1['fields'] = []
            hash1['fields'].push(hash2)
            post['attachments'].push(hash1)
            cnt += 1
        end

        res = post_to_slack(post.to_json)
        logger.debug('リザルトコードは' + res.code + 'でした🚬')
        RecentProblem.delete_all
    end


    def RecentProblem.post_daily_ranking
        num = []
        User.find_each do |u|
            next if u.point_day == 0
            hash = {}
            hash['name'] = u.name
            hash['point'] = u.point_day
            hash['count'] = u.solved_day
            num.push(hash)
        end
        return if num.empty?
        num.sort_by! {|u| u['point']}.reverse!

        hash2 = {}
        hash2['title'] = '🌸 Daily Ranking 🌸'
        hash2['value'] = ''
        cnt = 1
        num.each do |u|
            hash2['value'] += "[#{cnt}] #{u['name']} - #{u['point']} points, #{u['count']} problem" + (u['count']==1 ? '' : 's') + "\n"
            break if cnt == 10
            cnt += 1
        end
        hash1 = {}
        hash1['color'] = '#FA7C78'
        hash1['fields'] = []
        hash1['fields'].push(hash2)
        post = {}
        post['attachments'] = [hash1]

        res = post_to_slack(post.to_json)
        logger.debug('リザルトコードは' + res.code + 'でした🚬')
        User.update_all(point_day: 0, solved_day: 0)
    end


    def RecentProblem.post_weekly_ranking
        # 今日が日曜日であるときのみ実行
        return if Date.today.wday != 0
        num = []
        User.find_each do |u|
            next if u.point_week == 0
            hash = {}
            hash['name'] = u.name
            hash['point'] = u.point_week
            hash['count'] = u.solved_week
            num.push(hash)
        end
        return if num.empty?
        num.sort_by! {|u| u['point']}.reverse!

        hash2 = {}
        hash2['title'] = '🍔 Weekly Ranking 🍔'
        hash2['value'] = ''
        cnt = 1
        num.each do |u|
            hash2['value'] += "[#{cnt}] #{u['name']} - #{u['point']} points, #{u['count']} problem" + (u['count']==1 ? '' : 's') + "\n"
            break if cnt == 10
            cnt += 1
        end
        hash1 = {}
        hash1['color'] = '#FA6775'
        hash1['fields'] = []
        hash1['fields'].push(hash2)
        post = {}
        post['attachments'] = [hash1]

        res = post_to_slack(post.to_json)
        logger.debug('リザルトコードは' + res.code + 'でした🚬')
        User.update_all(point_week: 0, solved_week: 0)
    end


    def RecentProblem.post_monthly_ranking
        # 今日が1日であるときのみ実行
        return if Date.today.day != 1
        num = []
        User.find_each do |u|
            next if u.point_month == 0
            hash = {}
            hash['name'] = u.name
            hash['point'] = u.point_month
            hash['count'] = u.solved_month
            num.push(hash)
        end
        return if num.empty?
        num.sort_by! {|u| u['point']}.reverse!

        hash2 = {}
        hash2['title'] = '👑 Monthly Ranking 👑'
        hash2['value'] = ''
        cnt = 1
        num.each do |u|
            hash2['value'] += "[#{cnt}] #{u['name']} - #{u['point']} points, #{u['count']} problem" + (u['count']==1 ? '' : 's') + "\n"
            break if cnt == 10
            cnt += 1
        end
        hash1 = {}
        hash1['color'] = '#F52549'
        hash1['fields'] = []
        hash1['fields'].push(hash2)
        post = {}
        post['attachments'] = [hash1]

        res = post_to_slack(post.to_json)
        logger.debug('リザルトコードは' + res.code + 'でした🚬')
        User.update_all(point_month: 0, solved_month: 0)
    end


    def RecentProblem.post_to_slack body
        Dotenv.load
        uri = URI.parse(ENV['WEBHOOK_URL'])
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        req = Net::HTTP::Post.new uri.request_uri
        req.body = body
        http.request(req)
    end
end
