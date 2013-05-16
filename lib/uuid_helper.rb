require 'rubygems'
require 'uuidtools'
module UUIDHelper
  def before_create()
    #self.uuid = UUIDTools::UUID.random_create().to_s
    logger.error "****************************"  
      logger.error "#1111111111111"  
      #logger.error "#{err.backtrace.join('\n')}"  
      logger.error "****************************"
      
    if self.uuid.nil?
      self.uuid = "11" #UUID.timestamp_create().to_s
    end
  end
  
  def before_save()
    logger.error "****************************"  
      logger.error "#22222222222222"  
      #logger.error "#{err.backtrace.join('\n')}"  
      logger.error "****************************"
      
    #self.uuid = UUIDTools::UUID.random_create().to_s
    if self.uuid.nil?
      self.uuid = "22" #UUID.timestamp_create().to_s
    end
  end
end