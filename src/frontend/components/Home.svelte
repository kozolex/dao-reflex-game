<script>
  import logo from ".././assets/camp_logo.png"
  
  let inentity = null;
  let startTime;
  let endTime;
  let reactionTime;
  let reactionTimeSum = 0;
  let reactionTimeAvr;
  let buttonColor = "blue";
  let attempts = 3;
  let attemptsAll = attempts;

  let showImage = true;

  function toggleImage() {
    showImage = !showImage;
  }

  function changeColor() {
    if (buttonColor === "green"){
      buttonColor = "red";
      document.getElementById("reactionButton").innerHTML = "Wait";
      toggleImage();
    }else{
      buttonColor = "green"
      document.getElementById("reactionButton").innerHTML = "Klick";
      toggleImage();
    }
    document.getElementById("reactionButton").style.backgroundColor = buttonColor;
    startTime = new Date().getTime();
  }

  function calculateReactionTime() {
    if (buttonColor === "blue"){
      document.getElementById("reactionButton").innerHTML = "Wait";
      document.getElementById("reactionButton").style.backgroundColor = "red";
    }
    else if (buttonColor === "green" && attempts) {
      endTime = new Date().getTime();
      reactionTime = endTime - startTime;
      buttonColor = "red";
      document.getElementById("reactionButton").style.backgroundColor = buttonColor;
      document.getElementById("reactionTimeDisplay").innerHTML = "Czas reakcji: " + reactionTime + " ms";
    }
    else if(attempts == 0){
      document.getElementById("attempts").innerHTML = "END GAME";
    }
    else{
      reactionTime = 1000;
      document.getElementById("reactionTimeDisplay").innerHTML = "Too fast!!! Penalty + " + reactionTime + " ms";
    }
    setTimeout(changeColor, Math.random() * 2000 + 1000);
    reactionTimeSum += parseFloat(reactionTime);
    attempts--;
    reactionTimeAvr = parseFloat(reactionTimeSum / parseFloat(attemptsAll-attempts))
    document.getElementById("reactionTimeDisplayAve").innerHTML = reactionTimeAvr;
    document.getElementById("reactionTimeSum").innerHTML = reactionTimeSum;
    document.getElementById("attempts").innerHTML = "Attempts left: " + attempts;

  }
</script>


<div>
  <header class="App-header">
    <p class="slogan">Dao-Reflex-Game</p>
    <p class="">Check how fast your reflexes are. </p>
    <button id="reactionButton" on:click={calculateReactionTime} style="background-color: blue; color: white;">Klik to start and wait</button>
    <p id="reactionTimeDisplay">Your score will be here</p> <!-- Pole do wyświetlania czasu reakcji -->
    <p id="reactionTimeDisplayAve">Your score average</p>
    <p id="reactionTimeSum">Sum</p>
    <p id="attempts">How many attempts left</p>
    {#if showImage}
      <img id="motoko_logo" src="../assets/mot.png" alt="motoko_logo" height=100>
    {/if}
    
  </header>
</div>