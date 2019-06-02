require 'net/http'
require 'uri'

class Problem < ApplicationRecord
    has_many :recent_problems, dependent: :delete_all
    belongs_to :contest


    def self.pull
        Contest.pull
        sleep(1)

        uri = URI.parse("https://kenkoooo.com/atcoder/resources/merged-problems.json")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        req = Net::HTTP::Get.new uri.request_uri
        etag = Variable.find_by(key: 'problems_etag')
        if (etag.nil?)
            etag = Variable.new
            etag.key = 'problems_etag'
            etag.value = ''
            etag.save
        end
        req['If-None-Match'] = etag.value
        res = http.request(req)
        if res.code !='200'
            logger.debug('リザルトコードが' + res.code + 'だったから問題リストを更新しません👺')
            return
        end

        etag.value = res['etag']
        etag.save
        body = JSON.parse(res.body)
        body.each do |p|
            con = Contest.find_by(abbr: p['contest_id'])
            next if con.nil?
            next if Problem.exists?(abbr: p['id'])
            pro = Problem.new
            pro.name = p['title']
            pro.abbr = p['id']
            pro.url = "https://atcoder.jp/contests/#{con.abbr}/tasks/#{pro.abbr}"
            pro.point = (p['point']=='null' ? 100 : p['point'].to_i)
            pro.contest_id = con.id
            pro.save
        end
    end
end
