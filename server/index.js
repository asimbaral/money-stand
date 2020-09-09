const express = require('express');
const cors = require('cors');
const monk =  require('monk');

const app = express();

const payDB = monk(process.env.MONGO_URI || 'localhost/payment');
const pays = payDB.get('pays');

app.use(cors());
app.use(express.json());

app.set('view engine', 'ejs');

function setupQRLink(orderNum, stName, ordrList, ttlPrice){
    app.get(`/${orderNum}`, (req,res)=>{
        res.render('index', {data: {storeName: stName, orderList: ordrList, totalPrice: ttlPrice }});
        //res.render('index', {data: {storeName: "Billy's Store", orderList: ["scraps", "juice", "water"], totalPrice: 9 }});
    });
}  
//setupQRLink("556", "Billy's Store", ["scraps", "juice", "water"], 9);
app.get('/', (req, res) => {
    //res.render('index', {data: {orderNumber: 5}});
    res.send({ some: 'json' });
});
//db 
app.get('/pays', (req, res) => {
    pays
        .find()
        .then(pays => {
            res.json(pays);
        });
});;

app.post('/payment', (req, res) => {
    const paymentLink = {
        storeName: req.body.storeName.toString(),
        orderNumber: req.body.orderNumber.toString(),
        orderList: req.body.orderList.toString(),
        totalPrice: req.body.totalPrice.toString(),
        userName: req.body.userName.toString(),
    };
    pays
        .insert(paymentLink)
        .then(createdPays => {
            res.json(createdPays);
        });

    setupQRLink(paymentLink.orderNumber, paymentLink.storeName, paymentLink.orderNumber, paymentLink.totalPrice);
    link(paymentLink.orderNumber.toString(), paymentLink.userName);
});
   
function link(theLink, userName){
    app.get(`/${userName}`, (req, res) => {
        pays
            .find({"orderNumber": theLink})
            .then(pays => {
                //res.json(pays);
                res.json({ url: `http://localhost:5000/${thelink}` });
            });
    });;
}

let port = process.env.PORT || 5000;
app.listen(port, () => {
    console.log('Listening on http://localhost:5000');
}); 