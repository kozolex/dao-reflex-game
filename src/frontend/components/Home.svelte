<script>
  import logo_mot from ".././assets/mot.png";
  import finger from ".././assets/finger.png";
  import logo_df from ".././assets/logo_df.svg";
  import { backend } from "../../declarations/backend";
  import { AuthClient } from '@dfinity/auth-client';
  import { HttpAgent } from '@dfinity/agent';
  import { principal } from '../stores';
  import { daoActor } from '../stores';

  //Komunikacja z backend
  let name = '';
  let greeting = '';
  let memberStatus;
  let memberData;

  async function getGreeting() {
    greeting = await backend.greet(name);
  }
  let member = {
    name: 'KoZoL',
    score: 1000
  };

  let addMember = async () => {
    try {
      await actor.addMember(member);
      alert('Member added successfully');
    } catch (error) {
      alert(`Error adding member: ${error.message}`);
    }
  };

  async function getMember() {
    memberData = await actor.getMember();
  }

  const handleLogin = async () => {
    let authClient = await AuthClient.create();
    const identityProvider =
      process.env.DFX_NETWORK === 'ic'
        ? 'https://identity.ic0.app'
        : `http://127.0.0.1:4943/?canisterId=${process.env.CANISTER_ID_INTERNET_IDENTITY}`;

    await authClient?.login({
      onSuccess: () => {},
      identityProvider,
    });
    const p = authClient.getIdentity().getPrincipal();
    principal.set(p);
    loginStatus = p;
    const agent = new HttpAgent({ identity: p });
    const actor = createActor(canisterIdBackend, { agent });
    daoActor.set(actor);
  };

  let status = 'Click to start';
  let loginStatus = "Login with ID to save score";
  let color = 'blue';
  let startTime;
  let endTime;
  let reactionTimes = [];
  let reactionTime = "Response time";
  let highScore = 10000.0;
  let attempts = 3;
  let attemptsLeft = attempts;
  let averageScore = "Average reaction time";
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
  <p class="slogan"><img id="motoko_logo" src={logo_mot} alt="motoko_logo" height=80> Motoko-Reflex-Game <img id="finger" src={finger} alt="finger" height=100></p>
  <p>Check how fast your reflexes are. <br> It will be tested in the {attempts} attempts. <br>
    Win the game, get the note on hall of fame! </p>
  
  <button id="reactionButton" style="background-color: {color};" on:click={startGame}>{status}{#if currentTimeVisible}<p>{currentTime} ms</p>{/if}</button>
  <p>Response time: {reactionTime} ms</p>
  <p>Average reaction time: {averageScore} ms</p>
  <p>Best score: {highScore} ms</p>
  <p>Attempts left: {attemptsLeft}</p>
  <input bind:value={name} type="text" name="nazwa">
  <button on:click={getGreeting}>Get Greeting</button>
  <p>{greeting}</p>
  <button id="loginButton" on:click={handleLogin}><span>{loginStatus} </span><img id="logo_df" src={logo_df} alt="logo_df" style="height: 20px"></button>
  
  <p>{principal}</p>
  <button on:click={addMember}>Add your score</button>
  <p>{memberStatus}</p>
  <button on:click={getMember}>Get data member</button>
  <p>{memberData}</p>

</div>



<style>
  .game {
  text-align: center;
  font-size: 1.2em;
  line-height: 15px;
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
  font-size: 20px;
  padding: 10px 10px 10px 10px;
  /* Zaokrąglij przycisk */
  border-radius: 50%;
  /* Dodaj efekt 3D */
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.75);
  transition: all 0.1s ease 0s;
  /* Wielkość*/
  width: 125px;
  height: 125px;
  } 
  #reactionButton:active {
    /* Dodaj animację wciśnięcia */
    transform: scale(0.8);
  }
  #loginButton {
    align-items: center;
    height: 20px;
    height: 30px;
    
  }
</style>
