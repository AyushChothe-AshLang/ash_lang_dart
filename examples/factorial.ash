fn fact(num){
    if(num<=1){
        return 1;
    }
    return num*fact(num-1);
}

fn main(){
    let num = double(input("Enter Number: "));
    println(fact(num));
    print("Done");
}