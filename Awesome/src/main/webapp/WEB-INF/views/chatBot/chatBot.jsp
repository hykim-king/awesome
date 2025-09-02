<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI 챗봇</title>
    <style>
        /* 챗봇 컨테이너는 부모 요소의 크기를 따릅니다. */
        .chatbot-container {
            width: 100%;
            height: auto;
            background-color: #f4f4f4;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            border-radius: 8px;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            margin-bottom: 20px; /* 다른 위젯과의 간격 */
        }
        
        .chatbot-header {
            padding: 15px;
            background-color: #FFD54F;
            color: #3d3312;
            font-size: 1.2em;
            font-weight: bold;
            text-align: center;
            border-top-left-radius: 8px;
            border-top-right-radius: 8px;
        }

        #chat-window {
            height: 350px; /* 사이드바에 적절한 높이 설정 */
            overflow-y: auto;
            padding: 10px;
            background-color: #fff;
        }
        
        .message-container { display: flex; margin-bottom: 10px; }
        .user-message { justify-content: flex-end; }
        .user-message .bubble { background-color: #fff8e3; }
        .bot-message { justify-content: flex-start; }
        .bot-message .bubble { background-color: #e5e5ea; }
        .bubble {
            max-width: 80%;
            padding: 10px 14px;
            border-radius: 18px;
            word-wrap: break-word;
            font-size: 0.9em;
            line-height: 1.4;
        }

        .chat-input-container {
            display: flex;
            align-items: center;
            padding: 10px;
            border-top: 1px solid #ddd;
        }
        .chat-input {
            flex-grow: 1;
            padding: 10px;
            border-radius: 20px;
            border: 1px solid #ccc;
            margin-right: 8px;
            font-size: 1em;
        }
        .send-button {
            padding: 10px 20px;
            background-color: #3d3312;
            color: white;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            font-size: 1em;
            transition: background-color 0.2s;
        }
        .send-button:hover {
            background-color: #0056b3;
        }
         /*-- 챗봇 메시지(종민 추가) --*/
        .bot-list { margin: 0; padding-left: 18px; }
        .bot-list li { margin: 2px 0; }
        /* 플로팅 런처 버튼 */
		.chat-launcher{
		  position: fixed !important; 
		  right: 24px !important; 
		  bottom: 24px !important;
		  width: 56px !important; 
		  height: 56px !important; 
		  border-radius: 50% !important;
		  border: 0; background:#FFD54F; color:#fff; font-size:24px;
		  display:flex; align-items:center; justify-content:center;
		  box-shadow: 0 8px 24px rgba(0,0,0,.2);
		  cursor:pointer; z-index: 9998;
		}
		.chat-launcher:hover{ background:#FFF4D1  ; }
		
		/* 플로팅 챗봇 패널(처음엔 숨김). 기존 .chatbot-container 스타일을 덮어쓰기 위해 id 선택자 사용 */
		#chatbot-panel{
		  position: fixed; right: 24px; bottom: 90px;
		  width: 360px; max-height: 70vh;
		  box-shadow: 0 12px 28px rgba(0,0,0,.25);
		  border-radius: 12px; overflow: hidden; z-index: 9999;
		
		  transform: translateY(8px); opacity: 0; pointer-events: none;
		  transition: transform .2s ease, opacity .2s ease;
		}
		#chatbot-panel.is-open{
		  transform: translateY(0); opacity: 1; pointer-events: auto;
		}
		
		/* 패널 안 채팅 영역 높이(플로팅에 맞게 조정) */
		#chat-window{ height: 320px; }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
  <!-- 플로팅 챗봇 패널 (처음엔 닫힘: is-open 없음) -->
  <div id="chatbot-panel" class="chatbot-container" aria-hidden="true">
    <div class="chatbot-header">
      Hot Issue Bot
      <!-- (선택) 닫기 버튼: 스타일이 있다면 예쁘게 보입니다 -->
      <button type="button" class="chatbot-close" aria-label="닫기" style="position:absolute;right:8px;top:8px;background:transparent;border:0;color:#fff;font-size:20px;cursor:pointer;">×</button>
    </div>

    <div id="chat-window"></div>

    <div class="chat-input-container">
      <input type="text" class="chat-input" placeholder="기사 관련 질문을 입력하세요...">
      <button class="send-button" type="button">전송</button>
    </div>
  </div>

  <!-- 플로팅 런처 버튼 -->
  <button id="chat-launcher"
          class="chat-launcher"
          aria-controls="chatbot-panel"
          aria-expanded="false"
          title="AI 챗봇 열기">💬</button>

    <script>
        $(document).ready(function() {
            var chatWindow = $('#chat-window');
            var chatInput = $('.chat-input');
            var sendButton = $('.send-button');
            
            var $panel    = $('#chatbot-panel');
            var $launcher = $('#chat-launcher');
            var $closeBtn = $('.chatbot-close');
            
            function openPanel(){
                $panel.addClass('is-open').attr('aria-hidden','false');
                $launcher.attr('aria-expanded','true');
                setTimeout(function(){ chatInput.focus(); }, 50);
            }
            function closePanel(){
                $panel.removeClass('is-open').attr('aria-hidden','true');
                $launcher.attr('aria-expanded','false');
            }
            
            //런처 버튼/닫기 버튼 동작
            $launcher.on('click', function(){
              $panel.hasClass('is-open') ? closePanel() : openPanel();
            });
            $closeBtn.on('click', closePanel);

            //XSS 방지용 이스케이프(XSS가 된다면 사용자 권한으로 들어가서 여러가지 문제를 일으킬수 잇어서!!(예: 세션 탈취, 악성 스크립트 유포))
            function escapeHtml(s){
                return String(s).replace(/[&<>"']/g, function(c){
                  return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]);
                });
              }

            // 메시지를 화면에 추가하는 함수
		    function addMessage(sender, message) {
		      var containerClass = (sender === 'user') ? 'user-message' : 'bot-message';
		
		      // 기존: 문자열 템플릿 → 변경: jQuery로 엘리먼트 생성
		      var $wrap   = $('<div class="message-container '+containerClass+'"></div>');   
		      var $bubble = $('<div class="bubble"></div>');                                 
		
		      if(sender === 'bot'){                                        
		          var lines = String(message).split(/\r?\n/)                 
		                        .map(function(s){ return s.trim(); })
		                        .filter(Boolean);
		          if(lines.length >= 2){                                     
		            var $ul = $('<ul class="bot-list"></ul>');                                  
		          $.each(lines, function(_, t){
		            $ul.append('<li>'+escapeHtml(t)+'</li>');                           
		          });
		          $bubble.append($ul);                                                      
		        } else {
		          $bubble.text(message);                                                    
		        }
		      } else {
		        $bubble.text(message);                                                      
		      }
		
		      $wrap.append($bubble);                                                         
		      chatWindow.append($wrap);                                                       
		      chatWindow.scrollTop(chatWindow[0].scrollHeight);
		    }
            
		    //후속질문 트리거 감지
		    function isFollowUp(t){
		      return /(다른|더|또|없어)/.test(String(t));
		    }
		    
            // 메시지 전송 함수
            function sendMessage() {
                var userMessage = chatInput.val().trim();
                if (userMessage === '') {
                    return;
                }
                addMessage('user', userMessage);
                chatInput.val('');
                
                var follow = isFollowUp(userMessage);
                var url = follow
                  ? '${pageContext.request.contextPath}/chatbot/more'
                  : '${pageContext.request.contextPath}/chatbot/ask';
                
                  $.ajax({
                	url: url,
                    type: 'POST',
                    data: follow ? {} : { message: userMessage },
                    dataType: 'text',
                    success: function(response) {
                        addMessage('bot', response);
                    },
                    error: function(xhr, status, error) {
                        addMessage('bot', '죄송합니다. 챗봇과 통신 중 오류가 발생했습니다.');
                        console.error("AJAX Error: ", status, error);
                    }
                });
            }

            sendButton.on('click', sendMessage);

            chatInput.on('keypress', function(e) {
                if (e.which === 13) {
                    sendMessage();
                }
            });
        });
    </script>
</body>
</html>