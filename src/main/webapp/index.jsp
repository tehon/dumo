<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String cp = request.getContextPath(); %> <%--ContextPath 선언 --%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>Ik ben</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
    <!-- Bootstrap Core CSS -->
    <!-- <link href="css/bootstrap.min.css" rel="stylesheet"> -->
	<link href="<%=cp%>/resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	
    <!-- Custom CSS -->
    <!--  <link href="css/stylish-portfolio.css" rel="stylesheet"> -->
	<link href="<%=cp%>/resources/bootstrap/css/stylish-portfolio.css" rel="stylesheet">
	<!-- Custom CSS2 -->
	<link href="<%=cp%>/resources/css/custom.css" rel="stylesheet">
	
    <!-- Custom Fonts -->
    <!-- <link href="font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"> -->
    <link href="<%=cp%>/resources/bootstrap/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,700,300italic,400italic,700italic" rel="stylesheet" type="text/css"> 
    <!-- Custom Fonts2 -->
	<!-- <link href="http://fonts.googleapis.com/earlyaccess/jejugothic.css" rel="stylesheet" type="text/css">  -->
	
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    
    
    <!-- jQuery -->
	<script type="text/javascript" src="<%=cp%>/resources/bootstrap/js/jquery.js"></script>
	<!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script> -->
	
    <!-- Bootstrap Core JavaScript -->
	<script type="text/javascript" src="<%=cp%>/resources/bootstrap/js/bootstrap.js"></script>

 <script type="text/javascript">
 var stageOneEnd = false;
 var stageTwoEnd = false;
 var stargeThreeEnd =false;

 $(function() {
		// 창 크기 바뀌면 할 것...
	    $( window ).resize(function() {
	    	 var windowWidth = $(window).width()*2/3; //document -350

	    	 $("canvas").attr("width", windowWidth).attr("height", 500);
	    });
	    
 		// 캔버스 친구들
 		var canvas = document.getElementById("canvas");
 		var ctx = canvas.getContext("2d"); // 캔버스 객체 생성

 		var canvasTemp = document.createElement("canvas");
 		var tempContext = canvasTemp.getContext("2d");
 		var canvasBuffer;
 		var imgWidth = 0;
 		var imgHeight = 0;
 		var imageData = {};
 		var scrollVal = 0;
 		var speed = 1;
 		
 		var canvasWidth = 2937;//canvas.width;
 		var canvasHeight = 532;//canvas.height;
 		
 		// 스크롤 이미지
 		var scrollImg= new Image();
 				
 		// 기본 객체
 		var backGroundMusic; // 배경음악 객체 생성
 		var canvasPen; // 캔버스에 그림을 그리는 펜
 		var keyPressOn = {}; //키 배열, pressed - true
 		var spacekey = false; // 스페이스 키
 		var oneSpacekey =false; 
 		
 		// 플레이어 객체
 		var playerUnit={}; // 플레이어
 		var playerImgWalk1= new Image();
 		var playerImgWalk2= new Image();
 		var playerImgJump= new Image();
 		var playerWalkTime = 0;
 		var playerWalkTimeLimit =20;
 		
 		// 스테이지 1 적 객체
 		var EnemyHangul; // 스테이지1 적객체 배열
 		var hangulViewCount=1; // 화면에 보이는 적객체 수 설정
 		var EnemyHangulMax = 10; // 미리 준비해두는 적객체 최대수
 		// 단어장 DB에서 가져온 값을 여기다가 넣어야함니까  그럴꺼면 이 페이지로 이동 시킬때 모델안에 단어장DB가 JSON배열로 들어가있어야겠구뇽
 		// 힘내 미래의 나
 		// var hangulWord = "${wordDB}";
 		
 		
 		// 시동 걸기
 		function loadGame() {
 			// 기본 객체들 채워주기
 			canvasBuffer = document.createElement("canvas"); // 캔버스에 펜있다고 넣어주기
 			
 			// 백그라운드 이미지
 			scrollImg.src = "<%=cp%>/resources/images/city.png";
 			scrollImg.onload = loadImage;
 			
 			// 배경음악 객체 채워주는 함수 호출
 			makeBackGroungMusic(); 

 			// 플레이 객체들 채워주기
 			makePlayerUnit();
 			playerImgWalk1.src = "<%=cp%>/resources/images/charactor/female_walk1.png";
 			playerImgWalk2.src = "<%=cp%>/resources/images/charactor/female_walk2.png";
 			playerImgJump.src = "<%=cp%>/resources/images/charactor/female_jump.png";
 			
 			// 한글 적 객체 채우기
 			EnemyHangul= new Array();
 			createEnemyHangul(EnemyHangulMax); // 최대값 만큼 객체 생성
 		
 			// 창 자체에 이벤트 리스너를 설정 //document O, canvas X , window O
 			document.addEventListener("keydown", getKeyDown, false);
 			document.addEventListener("keyup", getKeyUp, false);
 			
 			// 게임 스타트
 			startGame();
 		}
 		
 		// 게임 실행
 		function startGame(){
 			
 			// 캐릭터 짬프는 키보드 입력 받는 곳에서 해결됨
 			// 캐릭터 짬프 애니메이션 - 3씩 올라갔다가 3씩 내려옴
 			// 점프 애니메이션이 실행되는 동안에는 점프 키 입력을 받아도 모른척 해야함
 			// 라잌 쿠키런
 						
 			// 적이 지정된 시간마다 움직임
 			setInterval(() => {
 				// 배경화면 스크롤 함수
 				// 스크롤 한바퀴 다돌아 간경우 스크롤을 초기화한다
 				if (scrollVal <= speed) { //1 5 0 2가 0오류 안남
 					scrollVal = canvasWidth - speed;
 				}
 				
 				// 지정된 속도를 기준으로 스크롤의 값이 늘어난다(그리는 위치가 변경된다)
 				scrollVal -= speed;
 				
 				// 단어 움직임 로직
 				useEnemyHangul();
 				
 				// 적객체와 플레이어 충돌 처리		 안됨
 				/* for(var i=0;i<EnemyHangul.length;i++){ // 적객 체 돌려
 					
 					var oneHangul = EnemyHangul[i];
 				
 					//console.log(oneHangul);
 				 	 if(oneHangul.use){
 				 		if(oneHangul.y=380 && spacekey){	
 				 			var bamX = oneHangul.x - playerUnit.x;
 					 		//console.log(playerUnit.width);
 					 		if(bamX<=playerUnit.width){
 					 			EnemyHangul[i].use=false;
 					 		}
 				 		}else if(oneHangul.y=420 && !spacekey){
 				 			
 				 			var bamX = oneHangul.x - playerUnit.x;
 					 		console.log(playerUnit.width);
 					 		if(bamX<=playerUnit.width){		 			
 					 			EnemyHangul[i].use=false;
 					 		}
 				 		}
 				 		
 					}
 				} */
 				
 				// 그리기
 				renderGame();
 			},  1000 / 60);  //60
 		}
 		
 		// 지우고 전체 다 다시 그려주는 곳
 		function renderGame(){
 			// 지우기
 			ctx.clearRect(0, 0, canvas.width, canvas.height);
 			
 			// 배경 그리기
 			imageData = tempContext.getImageData(canvasWidth - scrollVal,0, canvasWidth, canvasHeight);
 			ctx.putImageData(imageData, 0, 0, 0, 0, canvasWidth, imgHeight);

 			// 배경 스크롤을 그려주는 부분
 			imageData = tempContext.getImageData(0, 0, canvasWidth - scrollVal, canvasHeight);
 			ctx.putImageData(imageData, scrollVal,0 , 0, 0, imgWidth, canvasHeight);
 			
 			// 플레이어 그리기
 			if(!spacekey){ //playerUnit.jump
 				if(playerUnit.walk){
 					ctx.drawImage(playerImgWalk1,playerUnit.x,playerUnit.y);
 					
 					playerWalkTime++;
 					if(playerWalkTime>playerWalkTimeLimit){
 						playerUnit.walk=false;
 						playerWalkTime=0;
 					}
 				}
 				else{
 					ctx.drawImage(playerImgWalk2,playerUnit.x,playerUnit.y);
 					
 					playerWalkTime++;
 					if(playerWalkTime>playerWalkTimeLimit){
 						playerUnit.walk=true;
 						playerWalkTime=0;
 					}
 				}
 			}
 			else{
 				ctx.drawImage(playerImgJump,playerUnit.x,playerUnit.y);
 			}
 			
 			// 단어 그림
 			for(var i=0;i<EnemyHangul.length;i++){ // 적객 체 돌려
 				
 				var oneHangul = EnemyHangul[i];
 				
 			 	 if(oneHangul.use){
 					ctx.font="20px Georgia";
 					ctx.fillStyle = 'white';
 					ctx.fillText(oneHangul.word,oneHangul.x,oneHangul.y); // x, y
 						
 					if(oneHangul.x<-10){ //0
 						oneHangul.use= false;
 					}
 				}
 			}
 			
 		}
 	
 		// 배경 이미지 로딩
 		function loadImage() {
 			/* 사용된 이미지의 폭과 너비를 저장하고 그림용 펜의 역할을 수행하는 캔버스 템프에도 담아둔다  */
 			imgWidth =  scrollImg.width || scrollImg.naturalWidth;//scrollImg.width;
 			imgHeight = scrollImg.height || scrollImg.naturalHeight;//scrollImg.height;
 			canvasTemp.width = imgWidth;
 			canvasTemp.height = imgHeight;

 			/* 그림을 그리고 현재 그림의 테이터를 담아둔다 */
 			tempContext.drawImage(scrollImg, 0, 0, imgWidth, imgHeight);
 			imageData = tempContext.getImageData(0, 0, imgWidth, imgHeight);

 			/* 캔버스 버퍼 객체에 펜을 담는다 */
 			canvasBuffer = document.createElement("canvas");
 		}
 		
 		// 플레이어 객체 만드는 곳
 		function makePlayerUnit(){
 			
 			var imgWalkWidth = 80;
 			var imgWalkHeight = 110;
 			
 			playerUnit = {
 					x : 100,
 					y : 350,
 					width : imgWalkWidth,
 					height : imgWalkHeight,
 					walk:true
 			};
 		}

 		// 한글 객체를 만드는 곳
 		function createEnemyHangul(wordcount){
 			for (var i = 0; i < wordcount; i++) {
 				var enemy = {
 					x : 1000,
 					y : 600,
 					width:0,
 					height:0,
 					word:"",//Math.floor(Math.random() * 10);// 랜덤수 // 그냥 123 할까
 					wordCheck:true, // 단어의 정답 여부
 					use :false //1 캔버스에 그려주는 지 스킵하는지 용도
 				};
 				EnemyHangul.push(enemy);
 			}
 		}
 		// 한글 객체를 쓰는 곳
 		function useEnemyHangul() {
 			
 			// DB에서 가져온 배열중 
 			// 한개를 뽑아서 밑에 집어넣는다
 			
 			var useCount = 0;
 			// 화면에 보이는 단어 3개로 조정하기 위해서
 			for(var i=0; i<EnemyHangul.length;i++){
 				if(EnemyHangul[i].use){
 					useCount++;
 					// true인 친구들은 왼쪽으로 보냄
 					EnemyHangul[i].x=EnemyHangul[i].x-3;
 				}
 			}
 			// 화면에 보이는 게 hangulViewCount이하면 한개 내보냄
 			if(useCount<hangulViewCount){
 				// 랜덤 Y값 준비
 				var startY=((Math.random() <= 0.5) ? 350 : 420);//)*150;
 				// X값 초기화, Y값이랑 word값, use 값을 고쳐야함
 				
 				var bool = true;
 				while(bool){
 					var randomNum = Math.floor((Math.random() * 10));
 					if(!EnemyHangul[randomNum].use){
 						bool=false; // 반복문 내보냄
 						
 						EnemyHangul[randomNum].x=1000; // x바꿈
 						EnemyHangul[randomNum].y=startY; // Y바꿈
 						EnemyHangul[randomNum].word="ㅁㅁㅁㅁㅁㅁ";
 						EnemyHangul[randomNum].use=true;
 					}
 				}
 				
 			}
 		}

 		// 키 누름 
 		function getKeyDown(event) { 
 			var keyValue;
 			if (event == null) {
 				return;
 			} else {
 				keyValue = event.keyCode;
 				
 				if (keyValue == "123" || keyValue == "116"){} // f12 ,f5
 				else{
 					event.preventDefault(); //키값 들어오면 js에서만 해당 키를 이용함
 				}
 			}
 			if (keyValue == "87")
 				keyValue = "287"; //up 38
 			else if (keyValue == "83")
 				keyValue = "283"; //down 40
 			else if (keyValue == "65")
 				keyValue = "265"; //left 37
 			else if (keyValue == "68")
 				keyValue = "268"; //right 39
 			keyPressOn[keyValue] = true;
 				
 			// 점프
 			if (keyValue == "32") {
 				spacekey = true;
 	 			calcKeyInnput(); // 방향키 입력 // 플레이어 위치값 
 			}
 			//calcKeyInnput(); // 방향키 입력 // 플레이어 위치값 // 여기 두니까 스페이스 말고도 처리함
 		}
 		// 키 뗌 
 		function getKeyUp(event) {
 			var keyValue;
 			if (event == null) {
 				keyValue = window.event.keyCode;
 				window.event.preventDefault();
 			} else {
 				keyValue = event.keyCode;
 				
 				if (keyValue == "123" || keyValue == "116"){} // f12 ,f5
 				else{
 					event.preventDefault(); //키값 들어오면 js에서만 해당 키를 이용함
 				}
 			}
 			if (keyValue == "87")
 				keyValue = "287"; //up 38
 			else if (keyValue == "83")
 				keyValue = "283"; //down 40
 			else if (keyValue == "65")
 				keyValue = "265"; //left 37
 			else if (keyValue == "68")
 				keyValue = "268"; //right 39
 			keyPressOn[keyValue] = false;

 			// 점프
 			if (keyValue == "32") {
 				// 점프 꾸욱 누른다고 연점 되는거 아니니까 그냥 up에서 점프 처리하게 바꾸기
 				spacekey = false;
 				calcKeyInnput(); // 방향키 입력 // 플레이어 위치값 
 			}
 			//calcKeyInnput(); // 방향키 입력 // 플레이어 위치값 // 여기 두니까 스페이스 말고도 처리함
 		}
 		// 방향키 입력 처리
 		function calcKeyInnput() {

 			if (keyPressOn["287"] && playerUnit.y >= -playerUnit.height / 2)
 				//console.log("287");
 			if (keyPressOn["283"] && playerUnit.y <= canvas.height - playerUnit.height / 2)
 				//console.log("283");
 			if (keyPressOn["265"] && playerUnit.x >= -playerUnit.width / 2)
 				//console.log("265");
 			if (keyPressOn["268"] && playerUnit.x <= canvas.width - playerUnit.width / 2)
 				//console.log("268");
 	 			
 	 		console.log("1 : "+spacekey+","+playerUnit.y);
 			if(spacekey){
 				console.log("2 : "+spacekey+","+playerUnit.y);
 				if(!oneSpacekey){
 					console.log("3 : "+spacekey+","+playerUnit.y);
 				playerUnit.y-=175;
 				console.log("4 : "+spacekey+","+playerUnit.y);
 				oneSpacekey=true;
 				console.log("5 : "+spacekey+","+playerUnit.y);
 				}
 			}else{
 				console.log("6 : "+spacekey+","+playerUnit.y);
 				playerUnit.y+=175;
 				console.log("7 : "+spacekey+","+playerUnit.y);
 				oneSpacekey=false;
 				console.log("8 : "+spacekey+","+playerUnit.y);
 			}
 			// 그림 다시 그리기
 			renderGame();
 		}
 		
 		// 배경음악 객체 채워주기
 		function makeBackGroungMusic(){
 			backGroundMusic = document.createElement("audio");
 			backGroundMusic.volume = 1.0;
 			// BackGroundMusic.src = "<c:url value="../resources/sound/war.mp3"/>"; // 안됨
 			backGroundMusic.src = "<%=cp%>/resources/sound/war.mp3";
 			backGroundMusic.setAttribute('id', 'backGroundMusic');
 			document.body.appendChild(backGroundMusic);
 		}
 		
 		// 스타트 버튼 클릭 시 
 		$('#startBtn').click(function(){
     		$('#startBtn').remove(); // 스타트 버튼을 화면에서 없애기
 			loadGame(); // 시작버튼을 누르면 해당 함수가 실행되게 변경
 		});
 	});
</script>
</head>
<body>
    <!-- Navigation -->
    <a id="menu-toggle" href="#" class="btn btn-dark btn-lg toggle"><i class="fa fa-bars"></i></a>
    <nav id="sidebar-wrapper">
        <ul class="sidebar-nav">
            <a class="menu-close" href="#" class="btn btn-light btn-lg pull-right toggle"><i class="fa fa-times"></i></a>
            <li class="sidebar-brand">
                <a href="#top" class="menu-close">Ik ben</a>
            </li>
            <li>
                <a href="#top" class="menu-close">Game</a>
            </li>
            <li>
                <a href="#about" class="menu-close">Word</a>
            </li>
            <li>
                <a href="#services" class="menu-close">about</a>
            </li>
            <li>
                <a href="#portfolio" class="menu-close">git,blog</a>
            </li>
            <li>
                <a href="#contact" class="menu-close">Contact</a>
            </li>
        </ul>
    </nav>

    <!-- Header -->
    <header id="top" class="header">
         <div class="container">
            <div class="row">
                <div class="col-lg-12 text-center">
                    <h1>Ik ben</h1>
                    <canvas id="canvas" width="1000" height="500"></canvas>
					<div id="glassPane">
						<img id="startBtn"	src="<%=cp%>/resources/images/Media-Play-128.png" alt="PlayButton" align="middle" style="width: 150px; height: 150px;">
					</div>
                </div>
            </div>
            <!-- /.row -->
        </div>
        <!-- /.container -->
    </header>
<hr/>
	<!-- Game -->
	<section id="about" class="about">
	<div class="container">
		<div class="row">
			<div class="col-lg-12 text-center">
				<form action="">
				<input type="text"/>
				</form>
			</div>
		</div>
		<!-- /.row -->
	</div>
	<!-- /.container --> </section>
<hr/>
	<!-- Services -->
    <!-- The circle icons use Font Awesome's stacked icon classes. For more information, visit http://fontawesome.io/examples/ -->
    <section id="services" class="services bg-primary">
        <div class="container">
            <div class="row text-center">
                <div class="col-lg-10 col-lg-offset-1">
                    <h2>Our Services</h2>
                    <hr class="small">
                    <div class="row">
                        <div class="col-md-3 col-sm-6">
                            <div class="service-item">
                                <span class="fa-stack fa-4x">
                                <i class="fa fa-circle fa-stack-2x"></i>
                                <i class="fa fa-cloud fa-stack-1x text-primary"></i>
                            </span>
                                <h4>
                                    <strong>Service Name</strong>
                                </h4>
                                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit.</p>
                                <a href="#" class="btn btn-light">Learn More</a>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6">
                            <div class="service-item">
                                <span class="fa-stack fa-4x">
                                <i class="fa fa-circle fa-stack-2x"></i>
                                <i class="fa fa-compass fa-stack-1x text-primary"></i>
                            </span>
                                <h4>
                                    <strong>Service Name</strong>
                                </h4>
                                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit.</p>
                                <a href="#" class="btn btn-light">Learn More</a>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6">
                            <div class="service-item">
                                <span class="fa-stack fa-4x">
                                <i class="fa fa-circle fa-stack-2x"></i>
                                <i class="fa fa-flask fa-stack-1x text-primary"></i>
                            </span>
                                <h4>
                                    <strong>Service Name</strong>
                                </h4>
                                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit.</p>
                                <a href="#" class="btn btn-light">Learn More</a>
                            </div>
                        </div>
                        <div class="col-md-3 col-sm-6">
                            <div class="service-item">
                                <span class="fa-stack fa-4x">
                                <i class="fa fa-circle fa-stack-2x"></i>
                                <i class="fa fa-shield fa-stack-1x text-primary"></i>
                            </span>
                                <h4>
                                    <strong>Service Name</strong>
                                </h4>
                                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit.</p>
                                <a href="#" class="btn btn-light">Learn More</a>
                            </div>
                        </div>
                    </div>
                    <!-- /.row (nested) -->
                </div>
                <!-- /.col-lg-10 -->
            </div>
            <!-- /.row -->
        </div>
        <!-- /.container -->
    </section>

    <!-- Callout -->
    <aside class="callout">
        <div class="text-vertical-center">
            <h1>Vertically Centered Text</h1>
        </div>
    </aside>

    <!-- Portfolio -->
    <section id="portfolio" class="portfolio">
        <div class="container">
            <div class="row">
                <div class="col-lg-10 col-lg-offset-1 text-center">
                    <h2>Our Work</h2>
                    <hr class="small">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="portfolio-item">
                                <a href="#">
                                    <!-- <img class="img-portfolio img-responsive" src="img/portfolio-1.jpg"> -->
                                </a>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="portfolio-item">
                                <a href="#">
                                    <!-- <img class="img-portfolio img-responsive" src="img/portfolio-2.jpg"> -->
                                </a>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="portfolio-item">
                                <a href="#">
                                    <!-- <img class="img-portfolio img-responsive" src="img/portfolio-3.jpg"> -->
                                </a>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="portfolio-item">
                                <a href="#">
                                    <!-- <img class="img-portfolio img-responsive" src="img/portfolio-4.jpg"> -->
                                </a>
                            </div>
                        </div>
                    </div>
                    <!-- /.row (nested) -->
                    <a href="#" class="btn btn-dark">View More Items</a>
                </div>
                <!-- /.col-lg-10 -->
            </div>
            <!-- /.row -->
        </div>
        <!-- /.container -->
    </section>

    <!-- Call to Action -->
    <aside class="call-to-action bg-primary">
        <div class="container">
            <div class="row">
                <div class="col-lg-12 text-center">
                    <h3>The buttons below are impossible to resist.</h3>
                    <a href="#" class="btn btn-lg btn-light">Click Me!</a>
                    <a href="#" class="btn btn-lg btn-dark">Look at Me!</a>
                </div>
            </div>
        </div>
    </aside>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="row">
                <div class="col-lg-10 col-lg-offset-1 text-center">
                    <h4><strong>Start Bootstrap</strong>
                    </h4>
                    <p>3481 Melrose Place
                        <br>Beverly Hills, CA 90210</p>
                    <ul class="list-unstyled">
                        <li><i class="fa fa-phone fa-fw"></i> (123) 456-7890</li>
                        <li><i class="fa fa-envelope-o fa-fw"></i> <a href="mailto:name@example.com">name@example.com</a>
                        </li>
                    </ul>
                    <br>
                    <ul class="list-inline">
                        <li>
                            <a href="#"><i class="fa fa-facebook fa-fw fa-3x"></i></a>
                        </li>
                        <li>
                            <a href="#"><i class="fa fa-twitter fa-fw fa-3x"></i></a>
                        </li>
                        <li>
                            <a href="#"><i class="fa fa-dribbble fa-fw fa-3x"></i></a>
                        </li>
                    </ul>
                    <hr class="small">
                    <p class="text-muted">Copyright &copy; Your Website 2014</p>
                </div>
            </div>
        </div>
        <a id="to-top" href="#top" class="btn btn-dark btn-lg"><i class="fa fa-chevron-up fa-fw fa-1x"></i></a>
    </footer>

 <!-- Custom Theme JavaScript -->
    <script>
    // Closes the sidebar menu
    $(".menu-close").click(function(e) {
        e.preventDefault();
        $("#sidebar-wrapper").toggleClass("active");
    });
    // Opens the sidebar menu
    $("#menu-toggle").click(function(e) {
        e.preventDefault();
        $("#sidebar-wrapper").toggleClass("active");
    });
    // Scrolls to the selected menu item on the page
    $(function() {
        $('a[href*=#]:not([href=#],[data-toggle],[data-target],[data-slide])').click(function() {
            if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') || location.hostname == this.hostname) {
                var target = $(this.hash);
                target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
                if (target.length) {
                    $('html,body').animate({
                        scrollTop: target.offset().top
                    }, 1000);
                    return false;
                }
            }
        });
    });
    //#to-top button appears after scrolling
    var fixed = false;
    $(document).scroll(function() {
        if ($(this).scrollTop() > 250) {
            if (!fixed) {
                fixed = true;
                // $('#to-top').css({position:'fixed', display:'block'});
                $('#to-top').show("slow", function() {
                    $('#to-top').css({
                        position: 'fixed',
                        display: 'block'
                    });
                });
            }
        } else {
            if (fixed) {
                fixed = false;
                $('#to-top').hide("slow", function() {
                    $('#to-top').css({
                        display: 'none'
                    });
                });
            }
        }
    });
    </script>
</body>
</html>