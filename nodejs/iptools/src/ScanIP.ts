//https://www.cnblogs.com/mazey/p/6809457.html
//https://lellansin.wordpress.com/2014/04/30/node-js-%E7%AB%AF%E5%8F%A3%E6%89%AB%E6%8F%8F/



import {Socket} from "net";
import {HashMap} from "TypeScriptCollectionsFramework";

class ScanSocket {
    private socket: Socket = new Socket();
    private ip: string;
    private port: number;

    private msgs: string[] = ['error','connect',   'close'];
    private funcs:Function[] = [this.onerror, this.onconnect,  this.onclose];
    private cbs:HashMap<string,Function>=new HashMap<string,Function>();

    constructor(sip: string, p: number,cbb:HashMap<string,Function>) {
        this.ip = sip;
        this.port = p;
        this.cbs=cbb;

        for (let i = 0; i < this.msgs.length; i++) {
            this.socket.on(this.msgs[i], this.funcs[i].bind(this));

        }
        this.socket.setKeepAlive(false);
        this.socket.setNoDelay(true);
        this.socket.setTimeout(500);
    }
    get getRemoteIP():string{
        return this.ip;
    }
    public    scan():void {
        // console.time('port scan time ' + this.ip+" "+ this.port);
        this.socket.connect(this.port, this.ip);
        return  ;
    }
    private raiseCallback(s:string):void{
        if(this.cbs.containsKey(s)){
            this.cbs.get(s)(this);
        }
    }
    public onconnect ()  {
        // console.log('onConnect端口:' + this.socket.remoteAddress+" "+ this.socket.remotePort);
        this.raiseCallback('connect');
        this.socket.destroy();
    }

    public onerror(err: Error) {
        // console.log('onError:' + err.message);
    }

    public onclose() {
        this.raiseCallback('close');
        // console.timeEnd('port scan time '+ this.ip+" "+ this.port);

    }

}

class ScanIP {
    private startIP: string;
    private endIP: string;
    private port: number;
    private mapCallback:HashMap<string,Function>=new HashMap<string, Function>();
    private ipNums:number=0;

    constructor(sip: string, eip: string, p: number) {
        this.startIP = sip;
        this.endIP = eip;
        this.port = p;
        this.mapCallback.put("error",this.onSocketError.bind(this));
        this.mapCallback.put("close",this.onSocketClose.bind(this));
        this.mapCallback.put("connect",this.onSocketConnect.bind(this));
    };
    public onSocketClose(sock:ScanSocket ):void{
        // console.log("onSocketClose:"+sock.getRemoteIP );
        this.ipNums=this.ipNums-1;
        if(this.ipNums==0){
            console.timeEnd('port scan time');
        }
    }
    public onSocketConnect(sock:ScanSocket ):void{
        console.log("onSocketConnect:"+sock.getRemoteIP );

    }
    public onSocketError(err:Error,sock:ScanSocket ):void{
        console.log("onSocketError:"+err.message+sock.getRemoteIP );
    }
    public scan(timeout: number): void {
        console.time('port scan time');
        let int1: number = ScanIP.ip2int(this.startIP);
        let int2: number = ScanIP.ip2int(this.endIP);

        let sockets: ScanSocket[] = [];

        this.ipNums=int2-int1;
        console.log(this.ipNums+" listIP " + int1 + " " + int2);

        let cls: boolean = true;
        for (let i = int1; i < int2; i++) {
            if (cls) {

                let socket: ScanSocket = new ScanSocket(ScanIP.int2ip(i), this.port,this.mapCallback);
                sockets.push(socket);
                socket.scan();

            }
        }


        return ;
    }


    public static ip2int(ipp: String): number {
        let num: number = 0;
        let ip: string[] = ipp.split(".");
        num = Number(ip[0]) * 256 * 256 * 256 + Number(ip[1]) * 256 * 256 + Number(ip[2]) * 256 + Number(ip[3]);
        num = num >>> 0;
        return num;
    }

    //数字转IP
    public static int2ip(num: number): string {
        let str: string = "";
        let tt: number[] = new Array();
        tt[0] = (num >>> 24) >>> 0;
        tt[1] = ((num << 8) >>> 24) >>> 0;
        tt[2] = (num << 16) >>> 24;
        tt[3] = (num << 24) >>> 24;
        str = String(tt[0]) + "." + String(tt[1]) + "." + String(tt[2]) + "." + String(tt[3]);
        return str;
    }

    public listIP(ip1: string, ip2: string) {

        let int1: number = ScanIP.ip2int(ip1);
        let int2: number = ScanIP.ip2int(ip2);
        console.log("listIP " + int1 + " " + int2);
        for (let i = int1; i < int2; i++) {
            console.debug(ScanIP.int2ip(i) + "\n");
        }
    }
}

// new ScanIP("192.168.1.1","192.168.1.255",8182).listIP("192.168.1.1","192.168.1.255");
// let s=new ScanIP("192.168.1.1", "192.168.1.255", 8182);
// s.listIP("192.168.1.1", "192.168.1.255");
// new ScanIP("192.168.1.140", "192.168.1.150", 8182).scan(5000)
var x=new ScanIP("192.168.1.1", "192.168.1.255", 8182);
async function test() {

    await x.scan(100);

}
test();

console.log("AAA");
// var waitTill = new Date(new Date().getTime() + 60 * 1000);
// while(waitTill > new Date()){}