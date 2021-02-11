class BlowsingTwitter
    require 'selenium-webdriver'

    def initialize(user, pass)

        @driver = Selenium::WebDriver.for :chrome
        @driver.manage.timeouts.implicit_wait = 60
        # 指定したドライバの要素が見つかるまでの待ち時間を指定
        
        @driver.navigate.to "https://twitter.com/login"
        # URLを指定してアクセス
        
        @driver.find_element(:xpath, '//*[@id="react-root"]/div/div/div[2]/main/div/div/div[2]/form/div/div[1]/label/div/div[2]/div/input').send_keys(user)
        #user名入力
        
        @driver.find_element(:xpath, '//*[@id="react-root"]/div/div/div[2]/main/div/div/div[2]/form/div/div[2]/label/div/div[2]/div/input').send_keys(pass)
        #pass入力
        
        @driver.find_element(:xpath, '//*[@id="react-root"]/div/div/div[2]/main/div/div/div[2]/form/div/div[3]/div').click
        #loginボタンクリック
    end

    def tweet(msg)
        @driver.find_element(:xpath, '//*[@id="react-root"]/div/div/div[2]/header/div/div/div/div[1]/div[3]/a/div').click
        #ツイートするボタンクリック
        
        @driver.find_element(:xpath, '//*[@id="layers"]/div[2]/div/div/div/div/div/div[2]/div[2]/div/div[3]/div/div/div/div[1]/div/div/div/div/div[2]/div[1]/div/div/div/div/div/div/div/div/div/div[1]/div/div/div/div[2]/div').send_keys(msg)
        #メッセージ入力
        
        @driver.find_element(:xpath, '//*[@id="layers"]/div[2]/div/div/div/div/div/div[2]/div[2]/div/div[3]/div/div/div/div[1]/div/div/div/div/div[2]/div[4]/div/div/div[2]/div[4]').click
        #送信ボタンクリック    
    end
    
    def search(query)
        query = URI.encode_www_form_component(query)
        @driver.navigate.to "https://twitter.com/search?q="+query+"&src=typed_query&f=live"
    end

    def finish
        @driver.quit
        # ドライバを閉じる
    end
end
