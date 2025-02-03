package containers;

public abstract class Container {

	// Containers attributes

	private String name;
	private double width;
	private double length;
	private double height;
	private double expectedWeight;

	// Constructors

	Container() {
	}

	Container(String name, double height, double width, double length) {
		this.name = name;
		this.height = height;
		this.width = width;
		this.length = length;
	}

	// Getters and Setters

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public double getWidth() {
		return width;
	}

	public void setWidth(double width) {
		this.width = width;
	}

	public double getLength() {
		return length;
	}

	public void setLength(double length) {
		this.length = length;
	}

	public double getHeight() {
		return height;
	}

	public void setHeight(double height) {
		this.height = height;
	}

	public void setExpectedWeight(double weight) {
		this.expectedWeight = weight;
	}

	// Calculates the volume of container by multiplying the width, length and
	// height
	public double calculateVolume() {
		return this.height * this.width * this.length;
	}

	public abstract double shippingCost(double weight);

	public double getExpectedWeight() {
		return this.expectedWeight;
	}

	// PrintItem Info

	public void print() {

		System.out.println(" Container type: " + this.getName());
		System.out.println("Container dimension  " + this.getHeight() + "m * " + this.getWidth() + "m * "
				+ this.getLength() + "m");
		System.out.println("Volume of the container: " + calculateVolume() + " m3 ");

	}

}
