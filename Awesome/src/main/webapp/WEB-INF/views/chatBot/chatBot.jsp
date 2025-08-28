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
            background-color: #007bff;
            color: white;
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
        .user-message .bubble { background-color: #dcf8c6; }
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
            background-color: #007bff;
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
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>

    <div class="chatbot-container">
        <div class="chatbot-header">AI 기사 챗봇</div>
        <div id="chat-window">
        </div>
        <div class="chat-input-container">
            <input type="text" class="chat-input" placeholder="기사 관련 질문을 입력하세요...">
            <button class="send-button">전송</button>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            var chatWindow = $('#chat-window');
            var chatInput = $('.chat-input');
            var sendButton = $('.send-button');

            // 메시지를 화면에 추가하는 함수
            function addMessage(sender, message) {
                var containerClass = (sender === 'user') ? 'user-message' : 'bot-message';
                var bubbleHtml = '<div class="message-container ' + containerClass + '">' +
                                 '<div class="bubble">' + message + '</div>' +
                                 '</div>';
                chatWindow.append(bubbleHtml);
                chatWindow.scrollTop(chatWindow[0].scrollHeight);
            }

            // 메시지 전송 함수
            function sendMessage() {
                var userMessage = chatInput.val().trim();
                if (userMessage === '') {
                    return;
                }
                addMessage('user', userMessage);
                chatInput.val('');
                $.ajax({
                    url: '${pageContext.request.contextPath}/chatbot/ask',
                    type: 'POST',
                    data: {
                        message: userMessage
                    },
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