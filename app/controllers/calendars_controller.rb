class CalendarsController < ApplicationController

  def index
    get_week
    @plan = Plan.new
  end

  def create
    # binding.pry
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    @todays_date = Date.today
    # 例) 今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end
      
      wday_num = Date.today.wday + x # 今日の曜日のwdayを呼び出す。timesメソッドのxと連結
      if wday_num >= 7 # 7で繰り返す
        wday_num = wday_num -7
      end

      day = { month: (@todays_date + x).month, date: @todays_date.day + x, plans: today_plans, wday: wdays[wday_num]}
      @week_days.push(day)

    end

  end
end
