import Principal "mo:base/Principal";
import Result "mo:base/Result"; //members
import HashMap "mo:base/HashMap";//members
import Iter "mo:base/Iter";//members
import Text "mo:base/Text";
import Http "http";
actor class DAO(){
    public query func greet(name : Text) : async Text{
    return "Hello, " # name # " it's me Your backend !"; 
  };
    /////////////

    public type Member = {
        name : Text;
        score : Nat;
    };
    public type Result<A, B> = Result.Result<A, B>;
    public type HashMap<A, B> = HashMap.HashMap<A, B>;

    let dao : HashMap<Principal, Member> = HashMap.HashMap<Principal, Member>(0, Principal.equal, Principal.hash);

    public shared ({ caller }) func addMember(member : Member) : async Result<(), Text> {
        switch (dao.get(caller)) {
            case (?member) {
                return #err("Already a member");
            };
            case (null) {
                dao.put(caller, member);
                return #ok(());
            };
        };
    };

    public shared ({ caller }) func updateMember(member : Member) : async Result<(), Text> {
        switch (dao.get(caller)) {
            case (?member) {
                dao.put(caller, member);
                return #ok(());
            };
            case (null) {
                return #err("Not a member");
            };
        };
    };

    public shared ({ caller }) func removeMember() : async Result<(), Text> {
        switch (dao.get(caller)) {
            case (?member) {
                dao.delete(caller);
                return #ok(());
            };
            case (null) {
                return #err("Not a member");
            };
        };
    };

    public query func getMember(p : Principal) : async Result<Member, Text> {
        switch (dao.get(p)) {
            case (?member) {
                return #ok(member);
            };
            case (null) {
                return #err("Not a member");
            };
        };
    };

    public query func getAllMembers() : async [Member] {
        return Iter.toArray(dao.vals());
    };

    public query func numberOfMembers() : async Nat {
        return dao.size();
    };
  // Member - ends 
  //*
  type Proposal = {}; // To define


  public shared query (msg) func whoami() : async Principal{
    return msg.caller
  };


  public shared ({ caller }) func submitProposal(text : Text) : async {
    #Ok : Proposal;
    #Err : Text;
  } {
    return #Err("Your principal is : " # Principal.toText(caller));
  };

  public shared ({ caller }) func vote(proposalId : Int, yesOrNo : Bool) : async {
    #Ok : (Nat, Nat);
    #Err : Text;
  } {
    return #Err("Not implemented yet");
  };

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
      body = Text.encodeUtf8("This is a DAO controlled webpage - best Jokes appear HERE");
      headers = [("Content-Type", "text/html; charset=UTF-8")];
      status_code = 200 : Nat16;
      streaming_strategy = null;
    });
  };
};