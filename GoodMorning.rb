require_relative "BlowsingTwitter"

def get_morning_msg

    morning_msgs = ["グッドモーニング", "オハヨーハヨー", "おはようございます"]
    
    #語尾決定処理開始
    sw = Random.rand(6) - 2
    
    case sw
    when -2
        msg_end = "…"
    when -1
        msg_end = "。"
    else
        msg_end = ""
        sw.times do
            msg_end += "！"
        end
    end 
    #語尾決定処理終了

    msg = morning_msgs[Random.rand(morning_msgs.size)]+msg_end
    p (msg + "を生成しました。")
    return msg

end

def gen_twi_time
    #8時台か9時台か？
    hour = Random.rand(2) + 8
    
    min = 0

    if hour == 8
        #8:39~8:59(39+20)
        min = 39 + Random.rand(21)
    else
        #9:00~9:39 
        min = Random.rand(40)
    end

    p "次の日は"+hour.to_s+":"+min.to_s+"につぶやきます。"

    return {hour: hour, min: min}
end

#初期化
bT = BlowsingTwitter.new("user", "pass")
twi_time = gen_twi_time()

loop do
    t = Time.now
    
    if t.hour == twi_time[:hour] && t.min == twi_time[:min] 
        #朝の挨拶をする
        msg = get_morning_msg()
        bT.tweet(msg)
        p (t.to_s + "に" + msg + "をつぶやきました。")

    elsif t.hour == 12 && t.min == 0
        #翌日のつぶやく時刻を決定
        twi_time = gen_twi_time()      
    end

    sleep 60
end




