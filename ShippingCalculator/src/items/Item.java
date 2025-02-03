package items;

public class Item {
	// Attributes

	private String name;
	private double width;
	private double length;
	private double height;
	private double weight;
	private int quantity;
	private String unit;

	// Constructors
	Item() {
	}

	public Item(String name, double height, double width, double length, double weight, String unit, int quantity) {

		this.name = name;
		this.width = width;
		this.length = length;
		this.height = height;
		this.weight = weight;
		this.quantity = quantity;
		this.unit = unit;
	}

	// Getters and Setters

	public String getName() {
		return name;
	}

	public String getUnit() {
		return unit;
	}

	public double getWidth() {
		return width;
	}

	public double getLength() {
		return length;
	}

	public double getHeight() {
		return height;
	}

	public int getQuantity() {
		return quantity;
	}

	public double getWeight() {
		return weight;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public void setWidth(double width) {
		this.width = width;
	}

	public void setLength(double length) {
		this.length = length;
	}

	public void setHeight(double height) {
		this.height = height;
	}

	public void setWeight(double weight) {
		this.weight = weight;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public double calculateVolume() {
		double vol = (this.height * this.length * this.width);

		// Converts it to mt3. We assume the volume is in cm for all items.
		return this.quantity * vol * 0.000001;
	}

	public double converToKilo(double weight) {
		// In case unit is KG, or Kg, or kg
		if (this.unit.toLowerCase() == "g") {
			return weight / 1000;
		}
		return weight;

	}

	public double getWeightinKilo() {
		return this.converToKilo(this.weight);
	}

	// PrintItem Info

	public void print() {

		System.out.println("Item: " + this.getName());
		System.out.println("Item dimension (H*W*L): " + this.getHeight() + "cm * " + this.getWidth() + "cm * "
				+ this.getLength() + "cm");
		System.out.println("Weight: " + this.getWeight() + " " + this.unit);
		System.out.println("Total Weight: " + this.getWeight() * this.getQuantity() + " " + this.unit);
		System.out.println("Weight in Kg: " + this.converToKilo(getWeight()));
		System.out
				.println("Total Weight in kilograms: " + this.getQuantity() * this.converToKilo(getWeight()) + " kg ");
		System.out.println("Volume: " + this.calculateVolume() + " mt3 ");
		System.out.println("Quantity: " + this.getQuantity());
		System.out.println("");

	}

	public void add(Item items) {

	}

}
