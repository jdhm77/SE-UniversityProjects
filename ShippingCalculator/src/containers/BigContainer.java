package containers;

//Using inheritance we extend the Container class and using super allows to use the methods of the main class
public class BigContainer extends Container {

	public BigContainer(String name, double height, double width, double length) {
		super(name, height, width, length);
	}

	// This method calculate and establish that whatever the weight is, it would
	// return 1800
	public double shippingCost(double weight) {
		return 1800;
	}

}