require 'net/http'
require 'uri'

class User < ApplicationRecord
    has_many :recent_problems, dependent: :delete_all
    validates :name, presence: true, uniqueness: true


    def self.pull(id, mode = nil)
        user = User.find(id)
        if (user.nil?)
            logger.debug('id:' + id + 'のユーザーはいねえ👺')
            return
        end
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
            pro = Problem.find_by(abbr: p['problem_id'])
            next if pro.nil?
            next if user.solved.include?(pro.abbr)
            user.solved += ' ' + pro.abbr
            user.point_total += pro.point
            user.solved_total += 1
            next if !mode.nil?

            rpro = RecentProblem.new
            rpro.problem_id = pro.id
            rpro.user_id = id
            if rpro.save
                user.point_month += pro.point
                user.point_week += pro.point
                user.point_day += pro.point
                user.solved_month += 1
                user.solved_week += 1
                user.solved_day += 1
            end
        end
        user.save
    end


    def self.pull_all
        Problem.pull
        sleep(1)
        User.find_each do |u|
            pull(u.id)
            sleep(1)
        end
    end


    def self.initialize(id)
        Problem.pull
        sleep(1)
        pull(id, 1)
    end


#    def self.post_to_slack body
#        Dotenv.load
#        uri = URI.parse(ENV['WEBHOOK_URL'])
#        http = Net::HTTP.new(uri.host, uri.port)
#        http.use_ssl = true
#        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
#        req = Net::HTTP::Post.new uri.request_uri
#        req.body = body
#        http.request(req)
#    end
end
