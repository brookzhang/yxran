ssh -i yxran.pem ubuntu@54.241.26.155

chmod 0666 log/development.log

rvm pkg install openssl
rvm reinstall all --force

sudo apt-get install libsqlite3-dev

.bashrc
echo "[[ -s '$HOME/.rvm/scripts/rvm' ]] && . '$HOME/.rvm/scripts/rvm'" >> /home/ubuntu/.bashrc

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" 
 [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # This loads RVM into a shell session.
 
source ~/.bashrc   #/refresh bash
 
1.指导价格  实际销售金额
2.店员自己选择值班店子
3.调货 需要接收才到库
4.折扣系统不在前台显示。 店员直接填写售价和积分。 后台监督，售价-积分 和 折扣 相差多大。


rails g migration AddLookupProductStoreStockHistory
rails g migration AddMemberSaleTransferOrder

rails g model Warehouse name:string remark:string status:integer
rails g model Inventory warehouse_id:integer product_id:integer quantity:integer last_updated_at:datetime
rails g model History inventory_id:integer adjusted_by:integer adjusted_to:integer adjusted_type:string remark:string
rails g controller admin/Warehouses index new create edit update destroy
rails g controller admin/Inventories index new create edit update destroy
rails g controller admin/Histories index new create edit update destroy

$ git remote set-url origin git@github.com:user/repo.git

sudo apt-get install build-essential zlib1g-dev libssl-dev libreadline-dev git-core curl libyaml-dev libcurl4-nss-dev libsqlite3-dev apache2-threaded-dev -y
172.30.6.70
42.96.185.57

连接特定的 DNS 后缀: 
描述: Realtek PCIe GBE Family Controller
物理地址: ‎F4-6D-04-73-CF-AB
已启用 DHCP: 是
IPv4 地址: 172.30.5.246
IPv4 子网掩码: 255.255.252.0
获得租约的时间: 2013年3月29日 10:27:09
租约过期的时间: 2013年4月6日 10:27:07
IPv4 默认网关: 172.30.4.31
IPv4 DHCP 服务器: 172.30.4.72
IPv4 DNS 服务器: 172.30.4.72, 172.30.4.73
IPv4 WINS 服务器: 172.30.4.72, 172.30.4.73
已启用 NetBIOS over Tcpip: 是
连接-本地 IPv6 地址: fe80::f868:5559:96a4:1a34%12
IPv6 默认网关: 
IPv6 DNS 服务器: 

set HTTP_PROXY=http://172.30.4.63:3128
set HTTPS_PROXY=http://172.30.4.63:3128
set HTTP_PROXY=http://172.20.1.46:8999
set HTTPS_PROXY=http://172.20.1.46:8999

export http_proxy=http://172.30.4.63:3128
export http_proxy=http://172.20.1.46:8999
export https_proxy=http://172.20.1.46:8999
$ git config --global http.proxy http://172.20.1.46:8999
$ git config --global http.proxy http://172.30.4.63:3128

rails new Reviver
cd Reviver
# modify gemfile ,add railsadmin
bundle
rails g rails_admin:install
# rails admin code : ..\Ruby192\lib\ruby\gems\1.9.1\bundler\gems\rails_admin-f4f98ef40af1\app

# modify gemfile add cancan
bundle 
rails g cancan:ability
rails g controller Pages index about contact help
# modify routes add root :to=> 'pages#index'
rake db:migrate
rails g migration OrganizationUnitBaseStructure  #14:25 2012/5/18
rake db:rollback
rails g controller Order/part_order index add create edit save destroy
rails g controller Order/part_order_item index add create edit save destroy






rails new Mindew
# gem 'rails_admin', :git => 'https://github.com/sferik/rails_admin.git'
# gem 'thesilverspoon'
rails generate thesilverspoon:install
rake db:migrate
# change db/seeds.rb
rake db:seed
rails g cancan:ability

rails g model Part partnumber:string partname:string type:integer status:integer





$ rails generate scaffold Post name:string title:string content:text

rails new novelpool
git init
git add .
git commit -am "init"
# github.com create new repotery
git remote add origin https://brookzhang@github.com/brookzhang/novelpool.git
git push -u origin master


rails g migration initdatabase
rake db:migrate
rails g controller Pages
rails destroy controller Pages
rails g controller Pages home toplist about help
# edit routes

git config branch.master.remote origin
git config branch.master.merge refs/heads/master

git branch -m master development 
git branch -m published master 
git push origin master 

#insert test data
rails g model User
rails c
user = User.new
user.email="brook@brook.com"
......
user.save
reload! #when model class modified ,reload them in console

rails g migration AlterAuthorOfBook
rails g controller maintain/Sections index show new edit
rake routes  # show all routes

sudo gem sources -r http://rubygems.org/      #terminal ,remove source
sudo gem sources -a http://ruby.taobao.org    #add source




#============================operation============================
# 创建一个表及相关的mvc
$ rails generate model User name:string email:string    #User , not Users ,created a migrate in /db/migrate/, edit if needs.
$ rake db:migrate 
$ rails generate controller Users show                  #Users ,not User
$ rails generate controller maintian/Users show                  #Users ,not User
$ rails generate migration some_action_name_as_a_tag_only_needs_fullfil
$ rails generate migration AddPartNumberToProducts
$ rails generate migration AddPartNumberToProducts part_number:string
$ rails generate migration RemovePartNumberFromProducts part_number:string
$ rails generate migration AddDetailsToProducts part_number:string price:decimal


#============================rails:============================
$ rails new sample_app -T						#without testing code
$ rails server									#rails s,quit: ctrl+c
$ rails server --environment production
$ rails console									# rails c  ,quit ctrl+d
$ rails console --sandbox				#no changes
$ rails console test
$ first_user = User.first     =User.find(1) User.all

$ tail -f log/development.log					#show database log


# ============================gem:   ============================
$ set HTTP_PROXY=http://172.30.4.63:3128   #set proxy=http://172.30.4.63:3128 
$ gem install rails               # -p --http-proxy http://172.30.4.63:3128

  
# ============================rake:   ruby make============================
$ rake db:create
$ rake db:test:prepare
$ rake db:reset									#clear database
$ rake db:populate              # lib/tasks/sample_data.rake task :populate =>:environment 
$ rake db:rollback                #回滚到最近的一次migration执行的状态  
$ rake db:rollback STEP=3         #回滚最近的3次的迁移任务
$ rake db:migrate:redo            #重做迁移

# ============================git:============================
$ git config --global user.name "name"
$ git config --global user.email "mail"
$ git config --global http.proxy http://172.30.4.63:3128
$ git config --global alias.co checkout
$ git config --global co.editor "vim -f"
$ git config --global core.autocrlf false
$ git config --global github.user username		#connected with https 
$ git config --global github.token tokencode	#https security code
$ git init										#init repository for a new folder
$ git checkout -b modify-readme					#new branch
$ git status
$ git branch
$ git branch -d some-branch  / git branch -D modify-readme  #delte branch,-d needs merged all changes ,-D not care about changes.
$ git merge modify-readme		  
$ git add .                                     #add all include new file
$ git commit -m "message"                       #commit modified one file 
$ git commit -a                                 #commit all changes ,not include new files 
$ git commit -am "message"						          #short write
$ git mv README README.markdown                 #rename file
$ git log
$ git rm public/index.html						#tell git that a file should be removed
$ git add . / git commit -am "massage" / git checkout master / git merge other-branch / git push # merge a branch
$ git checkout master / git checkout -b new-branch      #make a new branch, and leave on new-branch


# ============================github:============================
Global setup:
 Set up git
  git config --global user.name "Brook"
  git config --global user.email brook_realize@126.com
      
Next steps:
  git init
  git add .
  git commit -m 'first commit'
  git remote add origin https://brookzhang@github.com/brookzhang/hybook.git
  git push -u origin master
  
$ git remote add origin https://brookzhang@github.com/brookzhang/fat_free_crm.git
$ git push origin master
$ git push origin master:master
$ git push
$ git clone https://brookzhang@github.com/brookzhang/first_app.git
$ git pull
$ git fetch
$ git push heroku master
$ git remote rm heroku
$ git remote add heroku git@heroku.com:brook.git


# ============================rspec:============================
$ rails generate rspec:install
$ rails generate integration_test layout_links
$ rspec spec/
$ bundle exec rspec spec/
$ time rspec spec/
$ rspec spec/models/user_spec.rb -e "should have an encrypted password attribute"





# ============================heroku:============================
$ sudo gem install heroku
$ heroku keys:add               #follow steps ,add ssh public key
$ heroku create

$ git push heroku master
$ heroku rake db:migrate
$ [sudo] gem install taps
$ heroku db:push								#push data to heroku
$ heroku console                #same as rails console on heroku


# ============================vim:============================
$ :w                                            #write = save
$ :q                                            #quit
$ d                                             #delete



# ============================ubuntu:============================
$ cd                                            #change directory
$ ls                                            #list
$ mv                                            #move
$ cp                                            #copy
$ rm                                            #remove file or directory
$ rm rf											                    #remove recursive force
$ rm -rf spec/views
$ ps -e | grep apt                              #show apt* process
$ sudo killall apt                              #kill process
$ sudo killall apt-get
 
 
 
 
 
