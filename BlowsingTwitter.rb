#
# twitterをブラウザで開いて，自動でつぶやいたり，ふぁぼしますw
#
class BlowsingTwitter
    require 'selenium-webdriver'

    #
    # Chromeを開いて，twitterにログインします。
    #
    # @param [Strings] user ユーザー名
    # @param [Strings] pass パスワード
    #
    def initialize(user, pass)

        #Chromeのドライバ
        @driver = Selenium::WebDriver.for :chrome

        # 指定したドライバの要素が見つかるまでの待ち時間を指定
        @driver.manage.timeouts.implicit_wait = 60
        
        # URLを指定してアクセス
        @driver.navigate.to "https://twitter.com/login"
        
        @driver.find_element(:xpath, '//*[@id="react-root"]/div/div/div[2]/main/div/div/div[2]/form/div/div[1]/label/div/div[2]/div/input').send_keys(user)
        #user名入力
        
        @driver.find_element(:xpath, '//*[@id="react-root"]/div/div/div[2]/main/div/div/div[2]/form/div/div[2]/label/div/div[2]/div/input').send_keys(pass)
        #pass入力
        
        #loginボタンクリック
        @driver.find_element(:xpath, '//*[@id="react-root"]/div/div/div[2]/main/div/div/div[2]/form/div/div[3]/div').click
    end

    #
    # 引数で受け取ったメッセージをツイートします。
    #
    # @param [Strings] msg メッセージ
    #
    #
    def tweet(msg)
        #ツイートするボタンクリック
        @driver.find_element(:xpath, '//*[@id="react-root"]/div/div/div[2]/header/div/div/div/div[1]/div[3]/a/div').click
        
        #メッセージ入力
        @driver.find_element(:xpath, '//*[@id="layers"]/div[2]/div/div/div/div/div/div[2]/div[2]/div/div[3]/div/div/div/div[1]/div/div/div/div/div[2]/div[1]/div/div/div/div/div/div/div/div/div/div[1]/div/div/div/div[2]/div').send_keys(msg)
        
        #送信ボタンクリック    
        @driver.find_element(:xpath, '//*[@id="layers"]/div[2]/div/div/div/div/div/div[2]/div[2]/div/div[3]/div/div/div/div[1]/div/div/div/div/div[2]/div[4]/div/div/div[2]/div[4]').click
    end
    
    #
    # 受け取ったクエリ文でtwitterの検索をします。
    #
    # @param [Strings] query twitterのクエリ文
    # @param [Boolean] only_following フォロー中アカウントのつぶやきに限定して検索するか（デフォルトはfalse）
    #
    def search(query, only_following = false)
        
        #パーセントエンコーディング
        query = URI.encode_www_form_component(query)
        
        #url 
        url = "https://twitter.com/search?q="+query+"&src=typed_query&f=live"
        
        #following限定検索か？
        if only_following
            url += "&pf=on"
        end
        
        #検索（ツイートは新しい順に表示）
        @driver.navigate.to url
        
        #5秒待つ
        sleep 5
        
        #更新する
        @driver.navigate.refresh
        
    end
    
    #
    # 引数で受け取ったクエリ文で検索し，最新のツイートをいくつかふぁぼします。
    #
    # @param [Strings] query twitterのクエリ文
    # @param [Boolean] only_following フォロー中アカウントのつぶやきに限定して検索するか（デフォルトはfalse）
    #
    def fav_some_tweets(query, only_following = false)

        search(query, only_following)

        # 現在位置＋5000pxに縦スクロール
        @driver.execute_script(%Q{window.scroll(0,window.scrollY + 5000);})

        #5秒後に画面内の未ふぁぼツイートにふぁぼする
        @driver.execute_script(%Q{
            setTimeout(
                function () {
                    // いいね！の要素を取得
                    var elems = document.body.querySelectorAll('div[data-testid="like"]');
            
                    // 取得できたいいね！の要素の回数分実行
                    for (var i = 0; i < elems.length; i++) {
            
                        // いいね！ボタンをクリック
                        elems[i].click();
                    }         
                }
            , 5000);
        })
    end

    #
    # 画面を閉じます
    #
    def finish
        # ドライバを閉じる
        @driver.quit
    end
end
