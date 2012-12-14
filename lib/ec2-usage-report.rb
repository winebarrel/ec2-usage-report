require 'csv'
require 'time'
require 'mechanize'

class EC2UsageReport
  def initialize(email, password)
    @email = email
    @password = password
  end

  def fetch(options = {})
    options[:end] ||= Time.now
    options[:start] ||= (options[:end] - 7 * 24 * 60 * 60)
    options[:end] = Time.parse(options[:end].to_s)
    options[:start] = Time.parse(options[:start].to_s)

    options[:periodType] ||= :days

    agent = Mechanize.new
    agent.user_agent_alias = 'Windows IE 7'

    page = agent.get('https://aws-portal.amazon.com/gp/aws/developer/account/usage-report.html?productCode=AmazonEC2')

    agent.page.form_with(:name => 'signIn') do |f|
      f.field_with(:name => 'email').value = @email
      f.field_with(:name => 'password').value = @password
      f.click_button
    end

    agent.page.form_with(:name => 'usageReportForm') do |f|
      select(f, :timePeriod, 'aws-portal-custom-date-range')

      select_time(f, 'start', options.delete(:start))
      select_time(f, 'end', options.delete(:end))

      options.each do |name, value|
        select(f, name, value)
      end

      f.click_button(f.button_with(:name => 'download-usage-report-csv'))
    end

    csv_rows = agent.page.kind_of?(Mechanize::File) ? CSV.parse((agent.page.body || '').strip) : nil

    if csv_rows
      csv_rows = csv_rows.map do |row|
        row.map {|i| i.to_s.strip }
      end
    end

    return csv_rows
  end # fetch

  private

  def select(form, name, value)
    form.field_with(:name => name.to_s).option_with(:value => value.to_s).select
  end

  def select_time(form, prefix, time)
    select(form, "#{prefix}Month", time.mon)
    select(form, "#{prefix}Day", time.day)
    select(form, "#{prefix}Year", time.year)
  end
end # EC2UsageReport
