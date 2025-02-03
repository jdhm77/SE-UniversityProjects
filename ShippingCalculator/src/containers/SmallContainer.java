package containers;

public class SmallContainer extends Container {
	// Using inheritance we extend the Container class and using super allows to use
	// the methods of the main class
	private double expectedWeight = 0;

	public SmallContainer(String name, double width, double length, double height) {
		super(name, width, length, height);

	}

	// This method check the remaining weight, in order to use the correct type of
	// small container
	public double shippingCost(double remainingWeight) {
		this.expectedWeight = remainingWeight;
		if (remainingWeight <= 500) {
			return 1000;
		} else {
			return 1200;
		}
	}
}
