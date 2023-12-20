<script>
  import logo from ".././assets/camp_logo.png"
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
  
  function endGame(){
    averageScore = (reactionTimes.reduce((a, b) => a + b, 0) / reactionTimes.length).toFixed(2);
    
    document.getElementById("reactionTimeDisplayAve").innerHTML = "Average reaction time:" + averageScore +  "ms";
    color = 'blue';
    status = 'Play Again?';
    document.getElementById("attempts").innerHTML = " ";
    reactionTimes = [];
    if (highScore>averageScore){
      highScore=averageScore;
      document.getElementById("reactionTimeDisplayHigh").innerHTML = "Best score:" + highScore + "ms";
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
      endTime = new Date();
      reactionTime = endTime - startTime;
      reactionTimes.push(reactionTime);
      document.getElementById("reactionTimeDisplay").innerHTML = "Response time: " + reactionTime + " ms";
      endRound();
    }
    /*Bad click*/
    else if (color === 'red') {
      reactionTime = 1000;
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
    startTime = new Date();
  }
</script>

<div>
  <header class="App-header">
    <p class="slogan"><img id="motoko_logo" src="../assets/mot.png" alt="motoko_logo" height=80> Motoko-Reflex-Game</p>
    
    <p class="">Check how fast your reflexes are. <br> It will be tested in the {attempts} attempts. </p>
    
    <button id="reactionButton" style="background-color: {color};" on:click={startGame}>{status}</button>

    <p id="reactionTimeDisplay"></p>
    <p id="reactionTimeDisplayAve"></p>
    <p id="reactionTimeDisplayHigh"></p>
    <p id="attempts">Attempts left: {attemptsLeft}</p>

  </header>
</div>

<style>
  .App-header {
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
  padding: 10px 20px;
  /* Zaokrąglij przycisk */
  border-radius: 50%;
  /* Dodaj efekt 3D */
  box-shadow: 0 5px 15px rgba(0,0,0,0.3);
  transition: all 0.3s ease 0s;
  /* Wielkość*/
  width: 125px;
  height: 125px;
  } 
  #reactionButton:active {
    /* Dodaj animację wciśnięcia */
    transform: scale(0.8);
  }

</style>
