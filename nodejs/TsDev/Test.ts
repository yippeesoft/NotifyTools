//https://blog.csdn.net/jasnet_u/article/details/81144026



class Demo{
    a:number;
    b:number;
    constructor(a:number,b:number){
        this.a=a;
        this.b=b;
    }

    sum():number{
        return this.a+this.b;
    }
}


var  demo=new Demo(9,7);
console.log(demo.sum());