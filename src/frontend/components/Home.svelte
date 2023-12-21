<script>
  import logo_mot from ".././assets/mot.png";
  import { backend } from "../../declarations/backend";
  let status = 'Click to start';
  let color = 'blue';
  let startTime;
  let endTime;
  let reactionTimes = [];
  let reactionTime;
  let highScore = 10000.0;
  let attempts = 5;
  let attemptsLeft = attempts;
  let averageScore;

  //Counetr
  var currentTime = 0;
        var timerInterval;

        function updateTimer() {
            document.getElementById("timer").textContent = (new Date() - startTime) + "ms";
        }

        function startTimer() {
            clearInterval(timerInterval);
            timerInterval = setInterval(updateTimer, 1);
        }

        function resetTimer() {
            clearInterval(timerInterval);
            currentTime = 0;
            document.getElementById("timer").textContent = " ";
        }

  //End game
  
  function endGame(){
    averageScore = (reactionTimes.reduce((a, b) => a + b, 0) / reactionTimes.length).toFixed(2);
    
    document.getElementById("reactionTimeDisplayAve").innerHTML = "Average reaction time:" + averageScore +  "ms";
    color = 'blue';
    status = 'Play Again?';
    document.getElementById("attempts").innerHTML = " ";
    reactionTimes = [];
    console.log(highScore, averageScore);
    if (highScore > averageScore){
      highScore = averageScore;
    }
  }
  function endRound(){
      /*End round*/
      if (reactionTimes.length === attempts) {
          endGame();
      }
      else {
        status = 'Wait...';
        color = 'red';
        setTimeout(changeToGreen, Math.random() * 2000 + 1000);
      }
      attemptsLeft = attempts-reactionTimes.length
      document.getElementById("attempts").innerHTML = "Attempts left:" + attemptsLeft;
  }

  function startGame() {
    /*First click*/
    if (color === 'blue') {
      status = 'Wait...';
      color = 'red';
      setTimeout(changeToGreen, Math.random() * 2000 + 1000);
    } 
    /*Good click*/
    else if (color === 'green') {
      resetTimer();
      endTime = new Date();
      reactionTime = endTime - startTime;
      reactionTimes.push(reactionTime);
      document.getElementById("reactionTimeDisplay").innerHTML = "Response time: " + reactionTime + " ms";
      endRound();
    }
    /*Bad click*/
    else if (color === 'red') {
      resetTimer();
      endTime = new Date();
      reactionTime = endTime - startTime + 1000;
      reactionTimes.push(reactionTime);
      status = 'Too fast - 1s penalty';
      color = 'red';
      document.getElementById("reactionTimeDisplay").innerHTML = "Penalty + " + reactionTime + " ms";
      setTimeout(changeToGreen, Math.random() * 2000 + 2000);
      endRound();
    }
  }
  
  function changeToGreen() {
    status = 'Now!!!';
    color = 'green';
    startTimer();
    startTime = new Date();
  }
</script>

<div class="game">
  
    <p class="slogan"><img id="motoko_logo" src=logo_mot alt="motoko_logo" height=80> Motoko-Reflex-Game</p>
    <p class="">Check how fast your reflexes are. <br> It will be tested in the {attempts} attempts. </p>
  
  <button id="reactionButton" style="background-color: {color};" on:click={startGame}>{status}<p id="timer"></p></button>

  <p id="reactionTimeDisplay"></p>
  <p id="reactionTimeDisplayAve"></p>
  <p id="reactionTimeDisplayHigh">Best score: {highScore} ms</p>
  <p id="attempts">Attempts left: {attemptsLeft}</p>
  <input id="name" type="text" name="nazwa">
  
    <button on:click={startTimer}>Start</button>
    <button on:click={resetTimer}>Reset</button>
</div>

<style>
  .game {
  text-align: center;
  font-size: 1.5em; /* Możesz dostosować tę wartość według swoich potrzeb */
  }
  .slogan{
    font-size: 1.75em;
    text-align: center;
    color: white;
    background: -webkit-linear-gradient(left, rgb(50, 5, 118), rgb(193, 17, 224), rgb(2, 57, 146), rgb(1, 171, 250), blue, indigo, violet);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
    transform: skewX(-10deg);
    margin: 50px 0;
  }

  #reactionButton {
  /* Powiększ przycisk */
  color: white;
  font-size: 18px;
  padding: 10px 10px;
  /* Zaokrąglij przycisk */
  border-radius: 20%;
  /* Dodaj efekt 3D */
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.622);
  transition: all 0.1s ease 0s;
  /* Wielkość*/
  width: 160;
  height: 120px;
  } 
  #reactionButton:active {
    /* Dodaj animację wciśnięcia */
    transform: scale(0.8);
  }

</style>
