//https://www.cnblogs.com/mazey/p/6809457.html

import * as net from 'net';

class ScanIP {
    private startIP:string;
    private endIP:string;
    private port:number ;

    constructor(sip: string,eip:string,p:number) {
        this.startIP = sip;
        this.endIP=eip;
        this.port=p;
    };

    public scan(timeout:number):boolean{
        timeout=timeout+1;
        return false;
    }

    public static ip2int(ipp:String):number{
       let num:number=0;
       let ip:string[]=ipp.split(".");
        num = Number(ip[0]) * 256 * 256 * 256 + Number(ip[1]) * 256 * 256 + Number(ip[2]) * 256 + Number(ip[3]);
        num = num >>> 0;
        return num;
    }

    //数字转IP
    public static int2ip(num:number):string{
        let str:string="";
        let tt:number[]=new Array();
        tt[0] = (num >>> 24) >>> 0;
        tt[1] = ((num << 8) >>> 24) >>> 0;
        tt[2] = (num << 16) >>> 24;
        tt[3] = (num << 24) >>> 24;
        str = String(tt[0]) + "." + String(tt[1]) + "." + String(tt[2]) + "." + String(tt[3]);
        return  str;
    }

    public listIP(ip1:string,ip2:string){

        let int1:number=ScanIP.ip2int(ip1);
        let int2:number=ScanIP.ip2int(ip2);
        console.log("listIP "+int1+" "+int2);
        for(let i=int1;i<int2;i++){
            console.debug(ScanIP.int2ip(i)+"\n");
        }
    }
}

new ScanIP("192.168.1.1","192.168.1.255",8182).listIP("192.168.1.1","192.168.1.255");
// let s=new ScanIP("192.168.1.1", "192.168.1.255", 8182);
// s.listIP("192.168.1.1", "192.168.1.255");

console.log("AAA");