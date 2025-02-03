package methods;

import items.Item;
import containers.Container;
import containers.SmallContainer;
import containers.BigContainer;

import java.util.List;
import java.util.Scanner;
import java.util.ArrayList;

public class Calculation {

	private List<Item> items;
	private int totalBigCont;
	private int totalSmallCont;
	private BigContainer bigCont = new BigContainer("Big Container", 2.59, 2.43, 12.01);
	private SmallContainer smallCont = new SmallContainer("Small Container", 2.59, 2.43, 6.06);

	public Calculation() {
		items = new ArrayList<>();
	}

	// Calculates the total volume of the items of the list
	double totalVolume() {
		double totalVolume = 0;
		// Sum up all items volume. Total Volume is in mt3.
		for (int i = 0; i < this.items.size(); i++) {
			totalVolume += this.items.get(i).calculateVolume();
		}
		return totalVolume;
	}

	// Calculates the total weight of the items
	double totalWeight() {
		double totalWeight = 0;
		// Sum up all items weight
		for (int i = 0; i < this.items.size(); i++) {
			totalWeight += this.items.get(i).getWeightinKilo() * this.items.get(i).getQuantity();
		}
		return totalWeight;
	}

	// This method selects the best shipping option by calculating the total volume
	// and weight of the items and updates the count of the containers
	void bestShipping() {

		double totalWeight = totalWeight();
		double totalVolume = totalVolume();

		// Checks big containers needed and calculates remaining volume
		this.totalBigCont = (int) (totalVolume / this.bigCont.calculateVolume());
		double remainingVolume = totalVolume - (this.totalBigCont * this.bigCont.calculateVolume());
		// Checks small container if there is remaining volume
		if (remainingVolume > 0) {
			if (remainingVolume < this.smallCont.calculateVolume()) {
				this.totalSmallCont++;
				this.smallCont.setExpectedWeight(calculateRemWeight(totalWeight, totalVolume, remainingVolume));

			} else {
				this.totalBigCont++;
			}

		}

		System.out.println("The Best Container Option is :\n");

		if (this.totalBigCont > 0) {
			System.out.println(" Big Container: " + this.totalBigCont + "\n");
			System.out.println("Details: ");
			this.bigCont.print();
			System.out.println();
		}
		if (totalSmallCont > 0) {
			System.out.println(" Small Container: " + totalSmallCont);
			System.out.println("Details: ");
			this.smallCont.print();
			System.out.println();
		}

	}

	// Calculates the weight of the remaining volume
	double calculateRemWeight(double totalWeight, double totalVolume, double totalCoveredVolume) {
		return totalWeight * totalCoveredVolume / totalVolume;

	}

	// Calculates the shipping price based on the container's count
	double shippingPrice() {

		double totalBigCont = this.totalBigCont * this.bigCont.shippingCost(0);
		double totalSmallCont = this.totalSmallCont * this.smallCont.shippingCost(this.smallCont.getExpectedWeight()); 
		return totalBigCont + totalSmallCont;
	}

	// Method function is to add items to the items list
	public void addItems(Item item) {
		this.items.add(item);
	}

	public void addOrder(ArrayList<Item>items) {
		for (int i = 0; i < items.size(); i++) {
			
			addItems(items.get(i));
		}

	}

	// Prints items and details
	void printItem() {
		for (int i = 0; i < this.items.size(); i++) {
			this.items.get(i).print();
		}

	}

	// Prints the details of the order like the shipping price, the best shipping
	// option and details
	public void printOrder() {

		this.printItem();

		this.bestShipping();
		System.out.println("The Shipping Price is: " + this.shippingPrice() + " euros ");

	}
}
