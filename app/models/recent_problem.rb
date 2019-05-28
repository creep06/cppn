require 'net/http'
require 'uri'

class RecentProblem < ApplicationRecord
    belongs_to :user

    def RecentProblem.post_recent
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

        Dotenv.load
        uri = URI.parse(ENV['WEBHOOK_URL'])
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        req = Net::HTTP::Post.new uri.request_uri
        req.body = post.to_json
        res = http.request(req)
        logger.debug('リザルトコードは' + res.code + 'でした🚬')

        RecentProblem.delete_all
    end


    def RecentProblem.post_daily_ranking
    end


    def RecentProblem.post_weekly_ranking
    end


    def RecentProblem.post_monthly_ranking
    end
end
