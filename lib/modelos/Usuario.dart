class Usuario {
  String _nome;
  String _senha;
  int _id;

  Usuario(this._nome, this._senha);

  Usuario.map(dynamic obj) {
    this._nome = obj['nome'];
    this._senha = obj['senha'];
    this._id = obj['id'];
  }

  String get nome => _nome;

  String get senha => _senha;

  int get id => _id;

  Map<String, dynamic> toMap() {
    /*
        {
           "id" : 1,
           "nome": "Joao",
           "senha: "joao12345"
         }
     */
    var mapa = new Map<String, dynamic>();
    mapa["nome"] = _nome;
    mapa["senha"] = _senha;

    if (id != null) {
      mapa["id"] = _id;
    }

    return mapa;
  }
  Usuario.fromMap(Map<String, dynamic> mapa) {
    this._nome = mapa['nome'];
    this._senha = mapa['senha'];
    this._id = mapa['id'];
  }
}
