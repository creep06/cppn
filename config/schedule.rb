set :output, "log/crontab.log"
set :environment, :production

every :day, at: "9:00 pm" do
    runner 'RecentProblem.post_daily_ranking'
end

every :Saturday, at: "9:05 pm" do
    runner 'RecentProblem.post_weekly_ranking'
end

every '10 21 1 * *' do
    runner 'RecentProblem.post_monthly_ranking'
end

every '20 * * * *' do
    runner 'User.get_all_problems'
end

every '30 * * * *' do
    runner 'RecentProblem.post_recent'
end
