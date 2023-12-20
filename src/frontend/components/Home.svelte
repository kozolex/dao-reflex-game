<script>
  import logo from ".././assets/camp_logo.png"
  let startTime;
  let endTime;
  let reactionTime;
  let reactionTimeSum = 0;
  let reactionTimeAvr;
  let buttonColor = "green";
  let attempts = 0;
  let attemptsAll = 0;
  let showStartButton = true;

  function changeColor() {
    if (buttonColor === "red"){
      buttonColor = "green";
      document.getElementById("reactionButton").innerHTML = "Click !";
    } else {
      buttonColor = "red"
      document.getElementById("reactionButton").innerHTML = "Wait...";
    }
    document.getElementById("reactionButton").style.backgroundColor = buttonColor;
    startTime = new Date().getTime();
  }

  function calculateReactionTime() {
    if (buttonColor === "green" && attempts) {
      endTime = new Date().getTime();
      reactionTime = endTime - startTime;
      buttonColor = "red";
      document.getElementById("reactionButton").style.backgroundColor = buttonColor;
      document.getElementById("reactionTimeDisplay").innerHTML = "Response time: " + reactionTime + " ms";
      reactionTimeSum += parseFloat(reactionTime);
      attempts--;
      if (attemptsAll-attempts > 0) {
        reactionTimeAvr = parseFloat(reactionTimeSum / parseFloat(attemptsAll-attempts)).toFixed(2);
        document.getElementById("reactionTimeDisplayAve").innerHTML = "Average response time: " + reactionTimeAvr + " ms";
      }
      document.getElementById("attempts").innerHTML = "Pozostało prób: " + attempts;
    }
    if (attempts > 0) {
      setTimeout(changeColor, Math.random() * 2000 + 1000);
    }
    else{
      document.getElementById("startButton").innerHTML = "Let's Start !!!";
    }
  }

  function startGame() {
    document.getElementById("startButton").innerHTML = "in progress";
    attempts = parseInt(3);
    attemptsAll = attempts;
    reactionTimeSum = 0;
    document.getElementById("reactionTimeDisplayAve").innerHTML = "";
    changeColor();
  }
</script>

<div>
  <header class="App-header">
    <p class="slogan">Motoko-Reflex-Game</p>
    <img id="motoko_logo" src="../assets/mot.png" alt="motoko_logo" height=100>
    <p class="">Check how fast your reflexes are. </p>
    
    <button id="reactionButton" on:click={calculateReactionTime} style="background-color: green;">Test button</button>
    {#if showStartButton}
    <button id="startButton" on:click={startGame}>Let's Start !!!</button>
    {/if}
    <p id="reactionTimeDisplay"></p>
    <p id="reactionTimeDisplayAve"></p>
    <p id="attempts"></p>

  </header>
</div>

<style>
  .App-header {
  text-align: center;
  font-size: 1.5em; /* Możesz dostosować tę wartość według swoich potrzeb */
  }

  #reactionButton {
  /* Powiększ przycisk */
  color: white;
  font-size: 20px;
  padding: 10px 20px;
  /* Zaokrąglij przycisk */
  border-radius: 50%;
  /* Dodaj efekt 3D */
  box-shadow: 0 5px 15px rgba(0,0,0,0.3);
  transition: all 0.3s ease 0s;
  /* Wielkość*/
  width: 100px;
  height: 100px;
  } 
  #reactionButton:active {
    /* Dodaj animację wciśnięcia */
    transform: scale(0.8);
  }

  #startButton {
  /* Powiększ przycisk */
  color: black;
  background-color: gold;
  font-size: 16px;
  padding: 10px 20px;
  /* Zaokrąglij przycisk */
  border-radius: 12px;
  /* Dodaj efekt 3D */
  box-shadow: 0 10px 10px rgba(0, 0, 0, 0.2);
  } 
  #startButton:active {
    /* Dodaj animację wciśnięcia */
    transform: scale(0.9);
  }

</style>