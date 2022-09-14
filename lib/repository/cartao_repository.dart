import 'package:financas_pessoais/database/database_manager.dart';
import 'package:financas_pessoais/models/cartao.dart';
import 'package:financas_pessoais/models/tipo_cartao.dart';


class CartaoRepository {
  Future<List<Cartao>> listarCartoes() async {
    final database = await DatabaseManager().getDatabase();
    final List<Map<String, dynamic>> rows = await database.query('cartoes');

    return rows
        .map(
          (row) => Cartao(
              id: row['id'],
              numero: row['numero'],
              tipoCartao: TipoCartao.values[row['tipoCartao']],
              dateVencimento: DateTime.fromMillisecondsSinceEpoch(row['dataVencimento']),
              agencia: row['agencia'],
              //banco: row['banco'],
             // contaBanco: row['contaBanco'],
              codigoSeguranca: row['codigoSeguranca'],
          )
        )
        .toList();
  }

  Future<void> cadastrarCartao(Cartao cartao) async {
    final database = await DatabaseManager().getDatabase();

    database.insert("cartoes", {    
      "id": cartao.id,
      "numero": cartao.numero,
      "tipoCartao": cartao.tipoCartao.index,
      "dataVencimento": cartao.dateVencimento.millisecondsSinceEpoch,
      "agencia": cartao.agencia,
      //"banco": cartao.banco.toString(),
      //"contaBanco": cartao.contaBanco,
      "codigoSeguranca": cartao.codigoSeguranca,
    });
  }

  Future<void> removerCartao(int id) async {
    final database = await DatabaseManager().getDatabase();
    await database.delete('cartoes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> editarCartao(Cartao cartao) async {
    final database = await DatabaseManager().getDatabase();
    return database.update(
        'cartoes',
        {
          "id": cartao.id,
          "numero": cartao.numero,
          "tipoCartao": cartao.tipoCartao.index,
          "dataVencimento": cartao.dateVencimento.millisecondsSinceEpoch,
          "agencia": cartao.agencia,
          //"banco": cartao.banco,
         // "contaBanco": cartao.contaBanco,
          "codigoSeguranca": cartao.codigoSeguranca,
        },
        where: 'id = ?',
        whereArgs: [cartao.id]);
  }
}
