<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html lang="ko">
	<head>
	<meta charset="UTF-8">
	<title>OMOK</title>
	
		<style>
		/* ===== reset ===== */
		* {
		    box-sizing: border-box;
		}
		
		a,
		a:visited,
		a:hover,
		a:active {
		    color: inherit;
		    text-decoration: none;
		}
		
		body {
		    margin: 0;
		    font-family: Arial, sans-serif;
		
		    background:
		        linear-gradient(rgba(225,225,225,0.7), rgba(225,225,225,0.7)),
		        url("img/back.png");
			background-position: center;
			background-size: cover;
			background-repeat: no-repeat;
			background-attachment: fixed;  
		        
		        
		}
		
		/* ===== top bar ===== */
		.top-bar {
		    background: #fff;
		    height: 80px;
		    display: flex;
		    align-items: center;
		    justify-content: space-between;
		    padding: 0 40px;
		    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
		}
		
		.logo {
		    font-size: 24px;
		    font-weight: 800;
		    padding-left: 50px;
		}
		
		.menu ul {
		    display: flex;
		    list-style: none;
		    padding: 0;
		    margin: 0;
		    gap: clamp(40px, 10vw, 300px);;
		    padding-right: 100px;
		}
		
		.menu li {
		    cursor: pointer;
		    font-weight: 600;
		    font-size: 20px;
		}
		
		.menu li.active {
		    color: #5483B9;
		}
		
		.top-bar {
		    background: #fff;
		    height: 80px;
		    display: flex;
		    align-items: center;
		    justify-content: space-between;
		    padding: 0 40px;
		    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
		}
		
		/* ===== main container ===== */
		.container {
			display : flex;
			flex-direction : column;
		    width: 1000px;
		    margin: 60px auto;
		    background-color: #fff;
		    border-radius: 15px;
		    padding : 70px;
		    padding-top: 130px;
		    
		}
		
		/* ===== search box ===== */
		.search-box {
			width : 580px;
			height : 237px;
		    background: #fff;
		    border-radius: 20px;
		    padding: 10px 35px;
		    text-align: left;
		    margin-bottom: 30px;
		    border: 6px solid #D4D4D4;
		    margin: 0 auto 30px auto;
			
		    
		}
		
		.search-inner {
		    display: flex;
		    justify-content: center;
		    gap: 5px;
		    margin-top : 40px;
		}

		.search-inner input {
		    width: 350px;
		    height: 48px;
		    border-radius: 14px;
		    border: 6px solid #ddd;
		    padding: 0 15px;
		    font-size: 16px;
		    
		}
		
		.search-inner button {
		    height: 48px;
		    padding: 0 24px;
		    border: none;
		    border-radius: 14px;
		    background: #7CB342;
		    color: #fff;
		    font-weight: 800;
		    font-size: 18px;
		    cursor: pointer;
		}
		
		/* ===== ready list ===== */
		.ready-box {
			width: 830px;
		    background: #fff;
		    border-radius: 20px;
		    box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.2);
		   	margin: 60px auto 0;   /* ← 이게 핵심 */
		}
		
		.ready-header {
			width: 830px;
			height: 67px;
		    background: #7CB342;
		    color: #fff;
		    padding: 12px 20px;
		    border-radius: 15px;
		    font-size: 26px;
		    font-weight: 800;
		    display: flex;
		    justify-content: space-between;
		    align-items: center;
		}
		
		.addRoombtn {
			width: 50px;
			height: 45px;
			font-size: 36px;
			font-weight: 700;
			background: transparent;    
		    border: 4px solid #ffffff;  
		    border-radius: 15px;         
		    color: #ffffff;   
		    cursor: pointer;
		    
		    display: flex;
		    align-items: center;
		    justify-content: center;
		}
		
		.room-list {
		    display: grid;
		    grid-template-columns: repeat(2, 1fr);
		    gap: 20px;
		    margin: 30px;
		    min-height: 600px;
		}
		
		.room-card {
			height : 180px;
		    border-radius: 15px;
		    padding: 20px;
		    border: 6px solid #85BE57;
		    cursor: pointer;
		    overflow: hidden;
		  
		}
		
		.room-card.orange {
		    border-color: #F0B061;
		}
		
		.room-title {
		    font-weight: 700;
		    font-size : 24px;
		    margin-bottom: 10px;
		}
		
		.room-info {
		    display: flex;
		    font-size: 18px;
		    font-weight: 500;
		    justify-content: space-between;
		    align-items: center;
		    padding: 20px 10px 0;
		    color: #3F3F3F;
		}
		
		.time {
		    font-size: 50px;
		    font-weight: 800;
		    color: #DCDCDC;
		}
		
		.empty-state {
		    display: none; /* 기본 숨김 */
		    text-align: center;
		    padding: 60px 0;
		}
		
		@keyframes floatCat {
		    0%   { transform: translateY(0); }
		    50%  { transform: translateY(-10px); }
		    100% { transform: translateY(0); }
		}
		
		.empty-state img {
		    animation: floatCat 3s ease-in-out infinite;
		    max-width: 500px;
		    width: 80%;
		    image-rendering: pixelated; /* 도트 감성 */
		}
		
		.empty-state p {
		    margin-top: 20px;
		    font-size: 20px;
		    font-weight: 700;
		    color: #666;
		    line-height: 1.4;
		}
		
		
		.player-line {
			max-width: 100%;
			white-space: nowrap;
			overflow: hidden;
			text-overflow: ellipsis;
		
			font-size: 18px;
			font-weight: 600;
			color: #333;
		}
		
		.player-line .vs {
			margin: 0 6px;
			color: #999;
			font-weight: 700;
		}

		

		
		
		</style>
	</head>

<body>

	<!-- ===== top bar ===== -->
	<header class="top-bar">
	    <div class="logo">OMOK</div>
	
	    <nav class="menu">
	        <ul>
	            <li class="active">
	            	<a href="RoomList.jsp">HOME</a>
	            </li>
	            <li>RANK</li>
	            <li>HOW</li>
	        </ul>
	    </nav>
	
	    <!-- 아바타 -->
	    <img src="${pageContext.request.contextPath}${player.avatar}"
     		onerror="this.src='${pageContext.request.contextPath}/img/default-avatar.jpg'"
     		alt="avatar" width="36" height="36">
	</header>
	
	<!-- ===== main ===== -->
	<div class="container">
	
	    <!-- search -->
	    <div class="search-box">
	        <h1>SEARCH</h1>
	        <div class="search-inner">
	        	<input type="text" id="searchInput" placeholder="SEARCH" onkeyup="searchRooms()"/>
	            <button>JOIN</button>
	        </div>
	    </div>
	
	    <!-- ready list -->
	    <div class="ready-box">
	        <div class="ready-header">
	            <span>READY</span>
	            <span>
	            	<button class="addRoombtn" onclick="openPopup()"> + </button>
	            </span>
	        </div>
	        
	        <!-- 빈 방 상태 -->
			<div id="emptyState" class="empty-state">
			    <img src="${pageContext.request.contextPath}/img/empty-room.png"
			         alt="empty room">
			    <p>아직 생성된 방이 없어요 🐱<br>+ 버튼을 눌러 방을 만들어보세요!</p>
			</div>
			
			<!-- 방 리스트 -->
			<div class="room-list" id="roomList"></div>


	    </div>
	
	</div>
	
<script src="${pageContext.request.contextPath}/js/roomList.js"></script>

<script>
function openPopup() {
    const w = 1000, h = 700;
    const left = (screen.width - w) / 2;
    const top  = (screen.height - h) / 2;

    window.open(
        "CreateRoomPopUp.jsp",
        "popup",
        `width=${w},height=${h},left=${left},top=${top}`
    );
}
</script>

</body>
</html>
