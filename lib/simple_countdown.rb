class SimpleCountdown
  def initialize
    @progress = 100
    @last_lenght = 8
  end

  def show(title, end_time)
    block = lambda { sleep 1; sleep 1;sleep 1;sleep 1;sleep 1;sleep 1;sleep 1; sleep 1 while remainding_time() > 0 }
    @title = title
    @end_time = end_time
    @delta = remainding_time()
    print @title + " "
    start_progress
    while remainding_time() > 0
      update
      sleep 1
#      update
    end
    finish_progress
  end

  def update
    progressbar_length = 106 + @last_lenght + @title.length
    move_cursor = "\e[#{progressbar_length}D"
    print move_cursor + (" " * progressbar_length) + move_cursor
    STDOUT.flush
    print "\e[33m#{@title} \e[0m"
    render_progress(remainding_time_percentage())
  end

  def method_missing(method, *args, &block)
    @self_before_instance_eval.send method, *args, &block
  end

  private

  def format_time (t)
    t = t.to_i
    sec = t % 60
    min  = (t / 60) % 60
    hour = t / 3600
    sprintf("%02d:%02d:%02d", hour, min, sec);
  end

  def render_progress(percent)
    @progress = percent
    printable_time = format_time(remainding_time())
    
    print "\e[33m[\e[0m"

    print "\e[31m=\e[0m" * [[percent.to_i, 46].min, 0].max
    print " " * [46 - [percent.to_i, 46].min, 46].min
    print "\e[33m#{printable_time}\e[0m"
    print "\e[31m=\e[0m" * [percent.to_i - 54, 0].max
    print " " * [46 - (percent.to_i - 54), 46].min

    print "\e[33m]\e[0m"

    new_lenght = printable_time.length
    if @last_lenght > new_lenght
      print " " * (@last_lenght - new_lenght)
      print "\e[#{@last_lenght - new_lenght}D"
    end
    @last_lenght = new_lenght

    STDOUT.flush
  end

  def start_progress
#    render_progress(100)
  end

  def finish_progress
    puts
  end

  def remainding_time_percentage
    remainding_time() * 100 / @delta
  end

  def remainding_time 
    @end_time - Time.now
  end

end
