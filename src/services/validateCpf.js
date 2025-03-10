const connect = require("../db/connect")

module.exports = async function validateCpf(cpf){


    const query = "SELECT id_usuario FROM usuario WHERE cpf=?"
    const values = [cpf];

    connect.query(query,values,(err, results)=>{
        if(err){

        }
        else if(results.lenghth > 0){
            const cpfCadastrado = results[0].id_usuario;

            if(userId)
        }

    })
}