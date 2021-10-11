import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:touchdown/domain/category.dart';
import 'package:touchdown/domain/game.dart';
import 'package:touchdown/domain/game_detail.dart';
import 'package:touchdown/domain/player.dart';
import 'package:touchdown/domain/teams.dart';
import 'package:touchdown/repository/auth_repository.dart';

class TeamsRepository {
  static TeamsRepository? _instance;

  TeamsRepository._();

  static TeamsRepository? get instance {
    if (_instance == null) {
      _instance = TeamsRepository._();
    }
    return _instance;
  }

  final _firestore = FirebaseFirestore.instance;
  final _auth = AuthRepository.instance;

  Team? _teams;

  Future<Team?> fetch() async {
    if (_teams == null) {
      final id = _auth!.firebaseUser?.uid;
      if (id == null) {
        return null;
      }
      final doc = await _firestore.collection('teams').doc(id).get();
      if (!doc.exists) {
        print("not team");
      }
      _teams = Team(doc);
    }
    return _teams;
  }

  Future<void> _updateLocalCache() async {
    final id = _auth!.firebaseUser?.uid;
    if (id == null) {
      return null;
    }
    final doc = await _firestore.collection('teams').doc(id).get();
    if (!doc.exists) {
      print("not user");
    }
    _teams = Team(doc);
  }

  void deleteLocalCache() {
    _teams = null;
  }

  Future<Team> getTeam({required Team team}) async {
    final doc = await _firestore.collection("teams").doc(team.uid).get();
    final _team = Team(doc);
    return _team;
  }

  /// Firestoreにユーザーを登録する
  Future<void> registerTeam(
      {String? uid, String? displayName, String? email, String? userID}) async {
    await _firestore.collection('teams').doc(uid).set(
      {
        "teamName": displayName,
        "email": email,
        "createdAt": Timestamp.now(),
        "uid": uid,
      },
    );
  }

  Future<void> updateTeamName({String? teamName, required Team team}) async {
    _firestore.collection('teams').doc(team.uid).update(
      {
        'teamName': teamName,
      },
    );
    _updateLocalCache();
  }

  Future<List<Categorys>> getCategory() async {
    final snapshot = await _firestore
        .collection("teams")
        .doc(_teams!.uid)
        .collection("category")
        .orderBy('createdAt', descending: true)
        .get();
    final teamsList = snapshot.docs.map((doc) => Categorys(doc)).toList();
    return teamsList;
  }

  Future<void> addCategory(String category, Team teams) async {
    _firestore.collection('teams').doc(teams.uid).collection('category').add(
      {
        'categoryName': category,
        'createdAt': Timestamp.now(),
      },
    );
  }

  Future<void> deleteCategory(
      {required Team team, required Categorys category}) async {
    _firestore
        .collection('teams')
        .doc(team.uid)
        .collection('category')
        .doc(category.uid)
        .delete();
  }

  Future<void> updateCategory(
      {String? categoryName,
      required Team team,
      required Categorys category}) async {
    _firestore
        .collection('teams')
        .doc(team.uid)
        .collection('category')
        .doc(category.uid)
        .update(
      {
        'categoryName': categoryName,
      },
    );
  }

  Future<List<Player>> getPlayer(Categorys category) async {
    final snapshot = await _firestore
        .collection("teams")
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection("player")
        .orderBy('uniformNumber', descending: false)
        .get();
    final playerList = snapshot.docs.map((doc) => Player(doc)).toList();
    return playerList;
  }

// OL
  Future<List<Player>> getOL(Categorys category) async {
    final snapshot = await _firestore
        .collection("teams")
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection("player")
        .where('position', isEqualTo: 'OL')
        .get();
    final playerList = snapshot.docs.map((doc) => Player(doc)).toList();
    return playerList;
  }

// QB
  Future<List<Player>> getQB(Categorys category) async {
    final snapshot = await _firestore
        .collection("teams")
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection("player")
        .where('position', isEqualTo: 'QB')
        .get();
    final playerList = snapshot.docs.map((doc) => Player(doc)).toList();
    return playerList;
  }

  // RB

  Future<List<Player>> getRB(Categorys category) async {
    final snapshot = await _firestore
        .collection("teams")
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection("player")
        .where('position', isEqualTo: 'RB')
        .get();
    final playerList = snapshot.docs.map((doc) => Player(doc)).toList();
    return playerList;
  }

// WR
  Future<List<Player>> getWR(Categorys category) async {
    final snapshot = await _firestore
        .collection("teams")
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection("player")
        .where('position', isEqualTo: 'WR')
        .get();
    final playerList = snapshot.docs.map((doc) => Player(doc)).toList();
    return playerList;
  }

// TE
  Future<List<Player>> getTE(Categorys category) async {
    final snapshot = await _firestore
        .collection("teams")
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection("player")
        .where('position', isEqualTo: 'TE')
        .get();
    final playerList = snapshot.docs.map((doc) => Player(doc)).toList();
    return playerList;
  }

  Future<void> addPlayer(int uniformNumber, String playerName, String position,
      Categorys category) async {
    _firestore
        .collection('teams')
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection('player')
        .add(
      {
        'uniformNumber': uniformNumber,
        'playerName': playerName,
        'position': position,
        'createdAt': Timestamp.now(),
        'firstdown': 0,
        'touchdown': 0,
        'scored': 0,
        'shot': 0,
        'participation': 0,
        'shittenParticipation': 0,
        'tokutenParticipation': 0,
      },
    );
  }

  Future<void> updatePlayer(
      {int? uniformNumber,
      String? playerName,
      String? position,
      required Categorys category,
      required Player player}) async {
    _firestore
        .collection('teams')
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection('player')
        .doc(player.uid)
        .update(
      {
        'uniformNumber': uniformNumber,
        'playerName': playerName,
        'position': position,
        'createdAt': Timestamp.now(),
      },
    );
  }

  Future<void> deletePlayer(
      {required Team team,
      required Categorys category,
      required Player player}) async {
    _firestore
        .collection('teams')
        .doc(team.uid)
        .collection('category')
        .doc(category.uid)
        .collection('player')
        .doc(player.uid)
        .delete();
  }

  Future<List<Game>> getGame(Categorys category) async {
    final snapshot = await _firestore
        .collection("teams")
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection("game")
        .orderBy('gameDate', descending: true)
        .get();
    final gameList = snapshot.docs.map((doc) => Game(doc)).toList();
    return gameList;
  }

  Future<void> addGame(
      DateTime gameDate, String opponentName, Categorys category) async {
    _firestore
        .collection('teams')
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection('game')
        .add(
      {
        'gameDate': Timestamp.fromDate(gameDate),
        'opponentName': opponentName,
        'createdAt': Timestamp.now(),
        'tokuten': 0,
        'shitten': 0,
        'allFirstDown': 0,
        'allShot': 0,
      },
    );
  }

  Future<void> updateGame(
      {required DateTime gameDate,
      String? opponentName,
      required Categorys category,
      required Game game}) async {
    _firestore
        .collection('teams')
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection('game')
        .doc(game.uid)
        .update(
      {
        'gameDate': Timestamp.fromDate(gameDate),
        'opponentName': opponentName,
      },
    );
  }

  Future<void> deleteGame(
      {Team? team, required Categorys category, required Game game}) async {
    _firestore
        .collection('teams')
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection('game')
        .doc(game.uid)
        .delete();
  }

  Future<List<GameDetail>> getGameDetail(Categorys category, Game game) async {
    final snapshot = await _firestore
        .collection("teams")
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection("game")
        .doc(game.uid)
        .collection('detail')
        .orderBy('scoreTime', descending: false)
        .get();
    final gameDetailList = snapshot.docs.map((doc) => GameDetail(doc)).toList();
    return gameDetailList;
  }

  Future<void> addTokutenDetail(
      int time,
      String tokutenTime,
      String? tokutenPlayer,
      String? tokutenPattern,
      Categorys category,
      Game game) async {
    _firestore
        .collection('teams')
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection('game')
        .doc(game.uid)
        .collection('detail')
        .add(
      {
        'rnrs': '得点',
        'scoreTime': time,
        'tokutenTime': tokutenTime,
        'tokutenPlayer': tokutenPlayer,
        'tokutenPattern': tokutenPattern,
        'teamUid': _teams!.uid,
        'categoryUid': category.uid,
        'gameUid': game.uid,
      },
    );
  }

  Future<void> addShittenDetail(int time, String shittenTime,
      String? shittenPattern, Categorys category, Game game) async {
    _firestore
        .collection('teams')
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection('game')
        .doc(game.uid)
        .collection('detail')
        .add(
      {
        'rnrs': '失点',
        'scoreTime': time,
        'shittenTime': shittenTime,
        'shittenPattern': shittenPattern,
        'teamUid': _teams!.uid,
        'categoryUid': category.uid,
        'gameUid': game.uid,
      },
    );
  }

  Future<void> deleteDetail(
      {required Team team,
      required Categorys category,
      required Game game,
      required GameDetail gameDetail}) async {
    _firestore
        .collection('teams')
        .doc(team.uid)
        .collection('category')
        .doc(category.uid)
        .collection('game')
        .doc(game.uid)
        .collection('detail')
        .doc(gameDetail.uid)
        .delete();
  }

// QB
  Future<void> addGameQB(
      {required Categorys category,
      required Game game,
      required Player player,
      int? touchdown,
      int? firstdown,
      int? participation,
      int? tokutenParticipation,
      int? shittenParticipation}) async {
    _firestore
        .collection('teams')
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection('game')
        .doc(game.uid)
        .collection('player')
        .doc(player.uid)
        .set(
      {
        'uniformNumber': player.uniformNumber,
        'playerName': player.playerName,
        'position': player.position,
        'firstdown': firstdown,
        'goal': touchdown,
        'participation': participation,
        'teamUid': _teams!.uid,
        'categoryUid': category.uid,
        'gameUid': game.uid,
        'playerUid': player.uid,
        'tokutenParticipation': tokutenParticipation,
        'shittenParticipation': shittenParticipation
      },
    );
  }

// OL
  Future<void> addGameOL({
    required Categorys category,
    required Game game,
    required Player player,
    int? scored,
    int? shot,
    int? participation,
  }) async {
    _firestore
        .collection('teams')
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection('game')
        .doc(game.uid)
        .collection('player')
        .doc(player.uid)
        .set(
      {
        'uniformNumber': player.uniformNumber,
        'playerName': player.playerName,
        'position': player.position,
        'shot': shot,
        'scored': scored,
        'participation': participation,
        'teamUid': _teams!.uid,
        'categoryUid': category.uid,
        'gameUid': game.uid,
        'playerUid': player.uid,
      },
    );
  }

// RB
  Future<void> addGameRB({
    required Categorys category,
    required Game game,
    required Player player,
    int? scored,
    int? shot,
    int? participation,
  }) async {
    _firestore
        .collection('teams')
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection('game')
        .doc(game.uid)
        .collection('player')
        .doc(player.uid)
        .set(
      {
        'uniformNumber': player.uniformNumber,
        'playerName': player.playerName,
        'position': player.position,
        'shot': shot,
        'scored': scored,
        'participation': participation,
        'teamUid': _teams!.uid,
        'categoryUid': category.uid,
        'gameUid': game.uid,
        'playerUid': player.uid,
      },
    );
  }

// WR
  Future<void> addGameWR({
    required Categorys category,
    required Game game,
    required Player player,
    int? scored,
    int? shot,
    int? participation,
  }) async {
    _firestore
        .collection('teams')
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection('game')
        .doc(game.uid)
        .collection('player')
        .doc(player.uid)
        .set(
      {
        'uniformNumber': player.uniformNumber,
        'playerName': player.playerName,
        'position': player.position,
        'shot': shot,
        'scored': scored,
        'participation': participation,
        'teamUid': _teams!.uid,
        'categoryUid': category.uid,
        'gameUid': game.uid,
        'playerUid': player.uid,
      },
    );
  }

// TE
  Future<void> addGameTE({
    required Categorys category,
    required Game game,
    required Player player,
    int? scored,
    int? shot,
    int? participation,
  }) async {
    _firestore
        .collection('teams')
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection('game')
        .doc(game.uid)
        .collection('player')
        .doc(player.uid)
        .set(
      {
        'uniformNumber': player.uniformNumber,
        'playerName': player.playerName,
        'position': player.position,
        'shot': shot,
        'scored': scored,
        'participation': participation,
        'teamUid': _teams!.uid,
        'categoryUid': category.uid,
        'gameUid': game.uid,
        'playerUid': player.uid,
      },
    );
  }

  Future<List<Player>> getGamePlayer(Categorys category, Game game) async {
    final snapshot = await _firestore
        .collection("teams")
        .doc(_teams!.uid)
        .collection('category')
        .doc(category.uid)
        .collection("game")
        .doc(game.uid)
        .collection('player')
        .orderBy('uniformNumber', descending: false)
        .get();
    final playerList = snapshot.docs.map((doc) => Player(doc)).toList();
    return playerList;
  }

  // **********************

  Future<List<Player>> getGameQB(
      {required Team team,
      required Categorys category,
      required Game game}) async {
    final snapshot = await _firestore
        .collection("teams")
        .doc(team.uid)
        .collection('category')
        .doc(category.uid)
        .collection("game")
        .doc(game.uid)
        .collection('player')
        .where('position', isEqualTo: 'QB')
        // .orderBy('uniformNumber', descending: false)
        .get();
    final playerList = snapshot.docs.map((doc) => Player(doc)).toList();
    return playerList;
  }

  Future<List<Player>> getGameOL(
      {required Team team,
      required Categorys category,
      required Game game}) async {
    final snapshot = await _firestore
        .collection("teams")
        .doc(team.uid)
        .collection('category')
        .doc(category.uid)
        .collection("game")
        .doc(game.uid)
        .collection('player')
        .where('position', isEqualTo: 'OL')
        // .orderBy('uniformNumber', descending: false)
        .get();
    final playerList = snapshot.docs.map((doc) => Player(doc)).toList();
    return playerList;
  }

  Future<List<Player>> getGameRB(
      {required Team team,
      required Categorys category,
      required Game game}) async {
    final snapshot = await _firestore
        .collection("teams")
        .doc(team.uid)
        .collection('category')
        .doc(category.uid)
        .collection("game")
        .doc(game.uid)
        .collection('player')
        .where('position', isEqualTo: 'RB')
        .get();
    final playerList = snapshot.docs.map((doc) => Player(doc)).toList();
    return playerList;
  }

  Future<List<Player>> getGameWR(
      {required Team team,
      required Categorys category,
      required Game game}) async {
    final snapshot = await _firestore
        .collection("teams")
        .doc(team.uid)
        .collection('category')
        .doc(category.uid)
        .collection("game")
        .doc(game.uid)
        .collection('player')
        .where('position', isEqualTo: 'RB')
        .get();
    final playerList = snapshot.docs.map((doc) => Player(doc)).toList();
    return playerList;
  }

  Future<List<Player>> getGameTE(
      {required Team team,
      required Categorys category,
      required Game game}) async {
    final snapshot = await _firestore
        .collection("teams")
        .doc(team.uid)
        .collection('category')
        .doc(category.uid)
        .collection("game")
        .doc(game.uid)
        .collection('player')
        .where('position', isEqualTo: 'RB')
        .get();
    final playerList = snapshot.docs.map((doc) => Player(doc)).toList();
    return playerList;
  }
}
