import 'package:financas_pessoais/models/tipo_cartao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import '../models/cartao.dart';

class CartaoListaItem extends StatelessWidget {
  final Cartao cartao;
  CartaoListaItem({Key? key, required this.cartao}) : super(key: key);

  //seperação dos números do cartão

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, '/cartao-detalhe',
            arguments: cartao);
        },
        child: Card(
          
          color: cartao.tipoCartao == TipoCartao.DEBITO 
                 ? Color.fromARGB(255, 208, 225, 255)
                 : Color.fromARGB(255, 240, 219, 126) ,
          child: SizedBox(
            height: 170,
            width: 300,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                       const Text("BANCO",style:  TextStyle(fontSize: 32)),
                       const SizedBox(width: 50),
                       Text(cartao.tipoCartao == TipoCartao.DEBITO ? 'Débito' : 'Crédito', style: TextStyle(fontSize: 16),)
                    ],
                  ),
      
                  const SizedBox(
                    height: 15,
                  ),
                  const Icon(Icons.bento),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    cartao.montarNumeroCartao(),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    DateFormat("MM/yyyy").format(cartao.dateVencimento),
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
