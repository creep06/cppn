require 'net/http'
require 'uri'

class Contest < ApplicationRecord
    has_many :problems, dependent: :destroy


    def self.pull
        uri = URI.parse("https://kenkoooo.com/atcoder/resources/contests.json")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        req = Net::HTTP::Get.new uri.request_uri
        etag = Variable.find_by(key: 'contests_etag')
        if (etag.nil?)
            etag = Variable.new
            etag.key = 'contests_etag'
            etag.value = ''
            etag.save
        end
        req['If-None-Match'] = etag.value
        res = http.request(req)
        if res.code !='200'
            logger.debug('リザルトコードが' + res.code + 'だったからコンテストリストを更新しません👺')
            return
        end

        etag.value = res['etag']
        etag.save
        body = JSON.parse(res.body)
        body.each do |c|
            next if c['rate_change'] == '-'
            next if Contest.exists?(abbr: c['id'])
            con = Contest.new
            con.name = c['title']
            con.abbr = c['id']
            con.save
        end
    end
end
