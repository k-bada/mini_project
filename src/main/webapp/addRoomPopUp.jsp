<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>방 만들기</title>

    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        h1 {
            font-size: 36px;
            font-weight: 800;
            align-self: flex-start;
            padding-left: 50px;
        }

        #addTitle {
            display: flex;
            flex-direction: column;
            width: 580px;
            height: 240px;
            border: 6px solid #D4D4D4;
            border-radius: 15px;
            align-items: center;
            justify-content: flex-start;
            gap: 10px;
        }

        #title {
            width: 430px;
            height: 50px;
            border-radius: 5px;
            border: 5px dashed #D4D4D4;
            font-size: 24px;
            padding-left: 15px;
            font-weight: 500;
        }

        .radio-box input[type="radio"]{
            display: none;
        }

        .radio-wrap {
            display: flex;
            gap: 70px;
            margin: 20px;
        }

        .radio-box {
            cursor: pointer;
            line-height: 110px;
        }

        .radio-box input:checked + .text-stroke {
            color: white;
            -webkit-text-stroke: 4px #7F7F7F;
            border: 4px dashed #F0B061;

        }

        .text-stroke {
            color: white;
            text-align: center;
            font-size: 64px;
            font-weight: 800;
            -webkit-text-stroke: 4px #DCDCDC;
            width: 200px;
            height: 120px;
            background-color: #f5f5f5;
            border-radius: 15px;
            border: 4px dashed #85BE57;
        }

        #addBtn {
            width: 314px;
            height: 70px;
            border-radius: 15px;
            background-color: #85BE57;
            color: white;
            font-size: 35px;
            font-weight: 700;
            border: 0px;
            text-align: center;
            line-height: 70px;
        }

        form {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            width: 1000px;
            height: 700px;
            gap: 15px;
        }

        

    </style>
</head>

<body>

    <form method="post" action="MINI_PROJECT/게임방">

        <div id="addTitle">
            <h1>방제</h1>
            <input type="text" name="title" id="title" placeholder="방 제목">
        </div>

        <div class="radio-wrap">
            <!-- 30s -->
            <label class="radio-box">
              <input type="radio" name="mode" value="30s" checked>
              <div class="text-stroke">30s</div>
            </label>

            <!-- 60s -->
            <label class="radio-box">
              <input type="radio" name="mode" value="60s">
              <div class="text-stroke">60s</div>
            </label>

          </div>

          <input type="submit" id="addBtn" value="방 만들기">
          

    </form>
    
</body>
</html>