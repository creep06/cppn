task :update => :environment do
    User.pull_all
end

task :post_hour => :environment do
    RecentProblem.post_recent
end

task :post_day => :environment do
    RecentProblem.post_daily_ranking
end

task :post_week => :environment do
    RecentProblem.post_weekly_ranking
end

task :post_month => :environment do
    RecentProblem.post_monthly_ranking
end
