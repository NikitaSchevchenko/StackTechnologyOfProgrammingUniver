class Logger
  def initialize
    @messages = []
  end

  def self.instance
    @instance ||= new
  end

  def log(message)
    @messages << message
  end

  def show_logs
    puts "Журнал повідомлень:"
    
    @messages.each do |message|
      puts "- #{message}"
    end
  end

  private_class_method :new
end


logger1 = Logger.instance
logger2 = Logger.instance


logger1.log("Користувач увійшов у систему")
logger2.log("Підключення до бази даних успішне")


puts "Один екземпляр: #{logger1.equal?(logger2)}"

logger1.show_logs