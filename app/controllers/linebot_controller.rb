class LinebotController < ApplicationController
  protect_from_forgery except: :sort

  # ルーティングで設定したcallbackアクションを呼び出す
  def callback
    body = request.body.read
    events = client.parse_events_from(body)

    events.each { |event|
      require "date"
      require 'nokogiri'
      require 'open-uri'

      #時刻表示を 時:分 に指定
      now = DateTime.now
      nowTime = now.strftime("%H:%M")
      
# 1 を入力した時のアクション(DBからデータ取得)
if event.message["text"].include?("1")
  nextBus = BusTimetableKaiseiSt.all
  nextBusKaisei = []
  nextBus.each do |nextBus|
    time = nextBus.time.strftime("%H:%M")
    if time >= nowTime
      nextBusKaisei << time
    end
end
#DBから現在時刻を起点に直近の３つのバスの時刻を出力

# 3 を入力した時のアクション(スクレイピングでデータ取得)
elsif event.message["text"].include?("３")
  urlOdakyu = 'https://www.odakyu.jp/cgi-bin/user/emg/emergency_bbs.pl'
  charset = nil
  htmlOdakyu = open(urlOdakyu) do |f|
    charset = f.charset
    f.read
  end

  docOdakyu = Nokogiri::HTML.parse(htmlOdakyu, nil, charset)
  docOdakyu.xpath('//div[@id="pagettl"]').each do |node|
    #スクレイピング情報の出力
    
else
  response =
      "↓↓番号を選択↓↓\n
      1. 開成駅→会社（シャトルバス）\n
      2. 会社→開成駅（シャトルバス）\n
      3. 電車の運行状況\n
      4. 会社周辺の天気\n
      5. 東京の天気\n\n
      ※半角数字でお願いします。"
end
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: response
          }
          client.reply_message(event['replyToken'], message)
        when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
          response = client.get_message_content(event.message['id'])
          tf = Tempfile.open("content")
          tf.write(response.body)
        end
      end
    }
    "OK"
  end
end