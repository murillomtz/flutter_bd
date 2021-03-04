import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../modelos/Usuario.dart';

class BDadosAjudante {
  static final BDadosAjudante _instance = new BDadosAjudante.internal();

  factory BDadosAjudante() => _instance;

  final String tabelaUsuario = "tabelaUsuario";
  final String colunaId = "id";
  final String colunaNome = "nome";
  final String colunaSenha = "senha";

  /*
     tabelaUsuario
     -------------------
      id | nome | senha
      -------------------
      1 | Joao | "riodejaneiro"
      ....
   */
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initBd();
    return _db;
  }

  BDadosAjudante.internal();

  initBd() async {
    Directory documentoDiretorio = await getApplicationDocumentsDirectory();
    String caminho = join(documentoDiretorio.path,
        "bd_principal.db"); // home://directory/files/bd_principal.db

    var nossoBD = await openDatabase(caminho, version: 1, onCreate: _onCreate);
    return nossoBD;
  }

  void _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $tabelaUsuario($colunaId INTEGER PRIMARY KEY,"
        "$colunaNome TEXT,"
        "$colunaSenha TEXT)");
  }

  //CRUD - CREATE, READ, UPDATE, DELETE

  //INSERIR
  Future<int> inserirUsuario(Usuario usuario) async {
    var bdCliente = await db;
    int res = await bdCliente.insert("$tabelaUsuario", usuario.toMap());
    return res;
  }

  //Retirar ou Pegar
  Future<List> pegarUsuarios() async {
    var bdCliente = await db;
    var res = await bdCliente.rawQuery("SELECT * FROM $tabelaUsuario");

    return res.toList();
  }

  //Contagem
  Future<int> pegarContagem() async {
    var bdCliente = await db;
    return Sqflite.firstIntValue(
        await bdCliente.rawQuery("SELECT COUNT(*) FROM $tabelaUsuario"));
  }

  //Pegar usuario atravez da sua ID
  Future<Usuario> pegarUsuario(int id) async {
    var bdCliente = await db;
    var res = await bdCliente.rawQuery("SELECT * FROM $tabelaUsuario"
        " WHERE $colunaId = $id");
    if (res.length == 0) return null;
    return new Usuario.fromMap(res.first);
  }

  //Apagar or deletar
  Future<int> apagarUsuario(int id) async {
    var bdCliente = await db;

    return await bdCliente.delete(tabelaUsuario,
        where: "$colunaId = ?", whereArgs: [id]);
  }

  //Atualizar usuario

  Future<int> atualizarUsuario(Usuario usuario) async {
    var bdCliente = await db;
    return await bdCliente.update(tabelaUsuario,
        usuario.toMap(), where: "$colunaId = ?", whereArgs: [usuario.id]);
  }

  Future fechar() async {
    var bdCliente = await db;
    return bdCliente.close();
  }
}
