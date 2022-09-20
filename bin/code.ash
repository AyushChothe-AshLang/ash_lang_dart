fn main(){
  let n1 = 0, n2 = 1;
  let count = 0;
  let nterms = 50;

  println("Fibonacci sequence:");
  while (count < nterms){
      println(n1);
      let nth = n1 + n2;
      n1 = n2;
      n2 = nth;
      count += 1;
  }
}