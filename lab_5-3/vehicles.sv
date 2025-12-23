class Vehicle;
  int wheels;

  function new(int w);
    wheels = w;
  endfunction

  virtual function void display();
    $display("Vehicle with %0d wheels", wheels);
  endfunction
endclass

class Car extends Vehicle;
  string brand;

  function new(int w, string b);
    super.new(w);
    brand = b;
  endfunction

  virtual function void display();
    $display("Car: %s with %0d wheels", brand, wheels);
  endfunction
endclass

class Truck extends Vehicle;
  int load_capacity;  // in tons

  function new(int w, int lc);
    super.new(w);
    load_capacity = lc;
  endfunction

  virtual function void display();
    $display("Truck with %0d wheels, load capacity %0d tons", wheels, load_capacity);
  endfunction
endclass

class Bike extends Vehicle;
  string bike_type;

  function new(int w, string t);
    super.new(w);
    bike_type = t;
  endfunction

  virtual function void display();
    $display("Bike: %s with %0d wheels", bike_type, wheels);
  endfunction
endclass

module test();
  Vehicle veh_h;  // base class handle
  Car car ;
  Truck truck;
  Bike bike;
  initial begin
    $display("\n=== Lab 5-3: Polymorphism Demonstration ===\n");

    // Car object
    car = new(4, "Toyota");
    veh_h = car;
    veh_h.display();  // calls Car's display()

    // Truck object
    truck = new(6, 10);
    veh_h = truck;
    veh_h.display();  // calls Truck's display()

    // Bike object
    bike = new(2, "Mountain Bike");
    veh_h = bike;
    veh_h.display();  // calls Bike's display()

    $display("\nPolymorphism demonstrated: same base handle calls different implementations!");
    #10 $finish;
  end
endmodule
