const router = require("express").Router();
const verifyJWT = require ('../services/verifyJWT')

const userController = require("../controllers/userController");
const orgController = require("../controllers/orgController");
const eventoController = require("../controllers/eventoController");
const ingController = require("../controllers/ingController");
const compraController = require("../controllers/compraController");
const upload = require("../services/upload");

router.post("/user", userController.createUser);
router.get("/user",verifyJWT, userController.getAllUsers);
router.put("/user", userController.updateUser);
router.delete("/user/:id", userController.deleteUser);
router.post("/login", userController.loginUser);

router.post("/org", orgController.createOrg);
router.get("/org", orgController.getAllOrgs);
router.put("/org", orgController.updateOrg);
router.delete("/org/:id_organizador", orgController.deleteOrg);

router.post("/evento",upload.single("imagem"), eventoController.createEvento);
router.get("/evento/imagem/:id",eventoController.getImagemEvento)
router.get("/evento", eventoController.getAllEventos);
router.get("/evento/data", eventoController.getEventosPorData);
router.get("/evento/:data", eventoController.getEventosPorData7Dias);
router.put("/evento", eventoController.updateEvento);
router.delete("/evento/:id_evento", eventoController.deleteEvento);

router.post("/ing", ingController.createIng);
router.get("/ing", ingController.getAllIngs);
router.get("/ingresso/evento/:id",ingController.getByIdEvento);
router.put("/ing", ingController.updateIng);
router.delete("/ing/:id_ingresso", ingController.deleteIng);

//Compracontroller
router.post("/comprasimples", compraController.registrarCompraSimples);
router.post("/compra", compraController.registrarCompra);





module.exports = router;