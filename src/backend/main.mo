import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Http "http";
actor {

  /*
  W tym przypadku, Proposal jest typem rekordu, który zawiera następujące pola:
  id : Unikalny identyfikator propozycji.
  text : Tekst propozycji.
  submitter : Principal, który zgłosił propozycję.
  yesVotes : Liczba głosów na “tak” dla propozycji.
  noVotes : Liczba głosów na “nie” dla propozycji.
  */
    type Proposal = {
    id : Int;
    text : Text;
    submitter : Principal;
    yesVotes : Nat;
    noVotes : Nat;
  };
  /*
  W tej implementacji, funkcja vote najpierw sprawdza, 
  czy propozycja o podanym proposalId istnieje w liście proposals.
   Jeśli nie, zwraca błąd. Jeśli tak, tworzy nową propozycję z
    aktualizowaną liczbą głosów i zastępuje starą propozycję w liście. 
  Następnie zwraca liczbę głosów “tak” i “nie” dla propozycji.
  */
  var proposals : [(Int, Proposal)] = []; // Lista propozycji

  /*
  Dokładnie ten sam efekt można uzskać tworząc:
  public shared query (msg) func whoami() : async Principal {
      msg.caller
  }; 
  */
  public shared query ({ caller }) func whoami() : async Principal {
      msg.caller
  }; 

  public shared ({ caller }) func vote(proposalId : Int, yesOrNo : Bool) : async {
    #Ok : (Nat, Nat);
    #Err : Text;
  } {
    let proposalOpt = proposals.find(p => p.0 == proposalId);
    switch (proposalOpt) {
      case (null) {
        return #Err("Propozycja o podanym ID nie istnieje");
      };
      case (?(id, proposal)) {
        let newProposal = {
          id = proposal.id;
          text = proposal.text;
          submitter = proposal.submitter;
          yesVotes = yesOrNo ? (proposal.yesVotes + 1) : proposal.yesVotes;
          noVotes = yesOrNo ? proposal.noVotes : (proposal.noVotes + 1);
        };
        proposals := proposals.replace(id, newProposal);
        return #Ok(newProposal.yesVotes, newProposal.noVotes);
      };
    };
  };


  public shared ({ caller }) func submitProposal(text : Text) : async {
    #Ok : Proposal;
    #Err : Text;
  } {
    return #Err("Your principal is : " # Principal.toText(caller));
  };
/*
  public shared ({ caller }) func vote(proposalId : Int, yesOrNo : Bool) : async {
    #Ok : (Nat, Nat);
    #Err : Text;
  } {
    return #Err("Not implemented yet");
  };
*/
  public query func getProposal(id : Int) : async ?Proposal {
    return null;
  };

  public query func getAllProposals() : async [(Int, Proposal)] {
    return [];
  };

  // Webpage
  public type HttpRequest = Http.Request;
  public type HttpResponse = Http.Response;
  public query func http_request(request : HttpRequest) : async HttpResponse {
    return ({
      body = Text.encodeUtf8("This is a DAO controlled webpage");
      headers = [("Content-Type", "text/html; charset=UTF-8")];
      status_code = 200 : Nat16;
      streaming_strategy = null;
    });
  };
};
