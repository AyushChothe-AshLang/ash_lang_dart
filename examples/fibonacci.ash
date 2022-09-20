fn fib(n){
  if(n<=1){
    return n;
  }
  return fib(n-1)+fib(n-2);
}

fn main(){
  let i = 0, n = 20;
  while(i<n){
    println(fib(i));
    i+=1;
  }
}