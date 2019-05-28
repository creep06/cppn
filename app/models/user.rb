require 'net/http'
require 'uri'

class User < ApplicationRecord
    has_many :problems, dependent: :delete_all
    has_many :recent_problems, dependent: :delete_all
    validates :name, presence: true, uniqueness: true

    def User.get_problems(id, mode = nil)
        user = User.find(id)
        uri = URI.parse("https://kenkoooo.com/atcoder/atcoder-api/results?user=#{user.name}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        req = Net::HTTP::Get.new uri.request_uri
        req['If-None-Match'] = user.etag
        res = http.request(req)
        if res.code !='200'
            logger.debug('リザルトコードが' + res.code + 'だったから更新しません👺')
            return
        end

        user.etag = res['etag']
        body = JSON.parse(res.body)
        body.each do |p|
            next if p['result'] != 'AC'
            next if Problem.exists?(name: p['problem_id'], user_id: id)
            next if (p['point']>2400) || ((p['point'].to_i%100) != 0)
            pro = Problem.new
            pro.name = p['problem_id']
            pro.url = "https://atcoder.jp/#{p['contest_id']}/tasks/#{p['problem_id']}"
            pro.point = p['point'].to_i
            pro.user_id = id
            if pro.save
                user.point_total += pro.point
                user.solved_total += 1
            end
            next if !mode.nil?

            rpro = RecentProblem.new
            rpro.name = p['problem_id']
            rpro.url = "https://atcoder.jp/#{p['contest_id']}/tasks/#{p['problem_id']}"
            rpro.point = p['point'].to_i
            rpro.user_id = id
            if rpro.save
                user.point_month += rpro.point
                user.point_week += rpro.point
                user.point_day += rpro.point
                user.solved_month += 1
                user.solved_week += 1
                user.solved_day += 1
            end
        end
        user.save
    end


    def User.get_all_problems
        User.find_each {|u| get_problems(u.id)}
    end


    def User.initialize_user(id)
        get_problems(id, 1)
    end
end
