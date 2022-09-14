import 'package:financas_pessoais/models/tipo_cartao.dart';

class Cartao {
  int? id;
  int numero;
  TipoCartao tipoCartao;
  DateTime dateVencimento;
  int agencia;
  //String banco;
  //int contaBanco;
  int codigoSeguranca;

  Cartao(
      {this.id,
      required this.numero,
      required this.tipoCartao,
      required this.dateVencimento,
      required this.agencia,
     // required this.banco,
      //required this.contaBanco,
      required this.codigoSeguranca});

    String montarNumeroCartao() {
    String conjunto1 = numero.toString().substring(0, 4);
    String conjunto2 = numero.toString().substring(4, 8);
    String conjunto3 = numero.toString().substring(8, 12);
    String conjunto4 = numero.toString().substring(12, 16);
    
    return "${conjunto1} ${conjunto2} ${conjunto3} ${conjunto4}";
  }
}

 
