<script>
  import logo_mot from ".././assets/mot.png";
  import { backend } from "../../declarations/backend";

  //Komunikacja z backend
  let name = '';
  let greeting = '';

  async function getGreeting() {
    greeting = await backend.greet(name);
  }

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
  let currentTimeVisible = false;

  let currentTime = 0;
  let timerInterval;

  function updateTimer() {
    currentTime = new Date() - startTime;
  }

  function startTimer() {
    clearInterval(timerInterval);
    timerInterval = setInterval(updateTimer, 1);
  }

  function resetTimer() {
    clearInterval(timerInterval);
    currentTime = 0;
  }

  function endGame(){
    averageScore = (reactionTimes.reduce((a, b) => a + b, 0) / reactionTimes.length).toFixed(2);
    color = 'blue';
    status = 'Play Again?';
    reactionTimes = [];
    if (highScore > averageScore){
      highScore = averageScore;
    }
    currentTimeVisible = false;
  }

  function endRound(){
    if (reactionTimes.length === attempts) {
      endGame();
    }
    else {
      status = 'Wait...';
      color = 'red';
      setTimeout(changeToGreen, Math.random() * 2000 + 1000);
    }
    attemptsLeft = attempts-reactionTimes.length;
    currentTimeVisible = false;
  }

  function startGame() {
    if (color === 'blue') {
      status = 'Wait...';
      color = 'red';
      setTimeout(changeToGreen, Math.random() * 2000 + 1000);
    } 
    else if (color === 'green') {
      resetTimer();
      endTime = new Date();
      reactionTime = endTime - startTime;
      reactionTimes.push(reactionTime);
      endRound();
    }
    else if (color === 'red') {
      resetTimer();
      endTime = new Date();
      reactionTime = endTime - startTime + 1000;
      reactionTimes.push(reactionTime);
      status = 'Too fast - 1s penalty';
      color = 'red';
      setTimeout(changeToGreen, Math.random() * 2000 + 2000);
      endRound();
    }
  }
  
  function changeToGreen() {
    status = 'Now!!!';
    color = 'green';
    startTimer();
    startTime = new Date();
    currentTimeVisible = true;
  }
</script>

<div class="game">
  <p class="slogan"><img id="motoko_logo" src={logo_mot} alt="motoko_logo" height=80> Motoko-Reflex-Game</p>
  <p>Check how fast your reflexes are. <br> It will be tested in the {attempts} attempts. </p>
  <button id="reactionButton" style="background-color: {color};" on:click={startGame}>{status}{#if currentTimeVisible}<p>{currentTime} ms</p>{/if}</button>
  <p>Response time: {reactionTime} ms</p>
  <p>Average reaction time: {averageScore} ms</p>
  <p>Best score: {highScore} ms</p>
  <p>Attempts left: {attemptsLeft}</p>
  <input bind:value={name} type="text" name="nazwa">
  <button on:click={getGreeting}>Get Greeting</button>
  <p>{greeting} aaa</p>

</div>


<style>
  .game {
  text-align: center;
  font-size: 1.5em;
  }
  .slogan{
    font-size: 1.75em;
    text-align: center;
    color: white;
    background: linear-gradient(to right, rgb(50, 5, 118), rgb(193, 17, 224), rgb(2, 57, 146), rgb(1, 171, 250), blue, indigo, violet);
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
  width: 160px;
  height: 120px;
  } 
  #reactionButton:active {
    /* Dodaj animację wciśnięcia */
    transform: scale(0.8);
  }

</style>
