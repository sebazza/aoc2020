using System;
using System.Collections;
using System.IO;
using System.Text.RegularExpressions;
using System.Collections.Generic;

class Colour {

    public Colour(string colour) => Name = colour;

    public string Name { get; set; }
    
    // Need colours to be equal if their the same name
    public override bool Equals(object obj) {
        if (obj == null) return false;
        return ((Colour)obj).Name == Name;
    }
    public override int GetHashCode() {
        return Name.GetHashCode();
    }
    public override string ToString() {
        return Name;
    }
}


// Bag contain other bags (inner bags) and can be contained in another bag (outer bags).
class Bag {

    public Colour Colour {get; set;}

    // Links to inner and outer bags so directed, weighted graph can be built based on rules.
    public HashSet<Bag> OuterBags {get; set;} =  new HashSet<Bag>();
    public HashSet<Tuple<Bag, int>> InnerBags {get; set;} = new HashSet<Tuple<Bag, int>>();

    public Bag(Colour colour) {
        this.Colour = colour;
    }

    public void addInnerBag(Bag bag, int num) {
        InnerBags.Add(new Tuple<Bag, int>(bag, num));
    }

    public void addOuterBag(Bag bag) {
        OuterBags.Add(bag);
    }
}




public class BagOfBags {

    // Dictionary of the bag rules.
    static Dictionary<Colour, Bag> bags = new Dictionary<Colour, Bag>();

    public static void Main(string[] args) {

        if (args.Length != 1) {
            Console.WriteLine("Enter input file.");
            return;
        }

        BagOfBags.readFile(args[0]);

        Console.WriteLine("Number of bags = {0}", bags.Count);
        
        Colour gold = new Colour("shiny gold");
        Bag goldBag = bags[gold];

        // How many bag colors can eventually contain at least one shiny gold bag?
        HashSet<Colour> colours = new HashSet<Colour>();
        addOuterBagColour(goldBag, colours);

        Console.WriteLine("Part one: Number of bag colours eventually containg at least one {0} bag is {1}",
            gold, colours.Count);

        int count = 0;
        countInnerBags(goldBag, ref count);
        Console.WriteLine("Part two: Number of bag colours inside {0} bag is {1}",
            gold, count);
        
    }


    // Read the input bag rules
    static void readFile(String fileName) {
        string[] lines = System.IO.File.ReadAllLines(fileName);
        // Split rule into colour and number of bags. 
        string pattern = @"^(\w+\s\w+)\sbags\scontain\s((\d+)\s(\w+\s\w+)\sbags?(,\s)?|no\sother\sbags)+\.$";
        foreach (string rule in lines)
        {
            //Console.WriteLine(rule);
            /*foreach (Match m in Regex.Matches(rule, pattern)) {
                Console.WriteLine("Match: {0}", m.Value);
                for (int groupCtr = 0; groupCtr < m.Groups.Count; groupCtr++) {
                    Group group = m.Groups[groupCtr];
                    Console.WriteLine("   Group {0}: {1}", groupCtr, group.Value);
                    for (int captureCtr = 0; captureCtr < group.Captures.Count; captureCtr++)
                    Console.WriteLine("      Capture {0}: {1}", captureCtr, 
                                        group.Captures[captureCtr].Value);
                }
            }*/
            Match match = Regex.Match(rule, pattern);
            string bagColour = match.Groups[1].Value;
            //System.Console.WriteLine("Bag colour is {0}", bagColour);
            // Group 1 has colour of bag; group 4 contains colours of contained bags:
            Bag bag = getOrCreateBag(new Colour(bagColour));
            for (int i = 0; i < match.Groups[4].Captures.Count; i++) {
                string colour = match.Groups[4].Captures[i].Value;
                int number = Int32.Parse(match.Groups[3].Captures[i].Value);
                //Console.WriteLine("Inner bag colour {0}, {1} of them", colour, number);
                Colour innerBagColour = new Colour(colour);
                Bag innerBag = getOrCreateBag(innerBagColour);
                bag.addInnerBag(innerBag, number);
                // Reciprocal
                innerBag.addOuterBag(bag);
            }

        }
        Console.WriteLine("Processed {0} lines", lines.Length);
    }



    static Bag getOrCreateBag(Colour colour) {

        Bag bag;
        if (bags.TryGetValue(colour, out bag)) {
        } else {
            bag = new Bag(colour);
            bags.Add(colour, bag);
            //Console.WriteLine("Added {0} bag: {1}", colour, colour.GetHashCode());
        }
        
        return bag;
    }

    // Recurse bags, keeping track of colour of outer bags encountered.
    static void addOuterBagColour(Bag bag, HashSet<Colour> bagColourSet) {
        foreach (Bag b in bag.OuterBags)
        {
            if (bagColourSet.Add(b.Colour)) {
                //Console.WriteLine("Added {0}", b.Colour );
                addOuterBagColour(b, bagColourSet);
            }
        }
    }

    // Recurse bags, counting number of inner bags.
    static void countInnerBags(Bag bag, ref int count) {
        foreach (Tuple<Bag, int> b in bag.InnerBags) {
            for (int i = 0; i < b.Item2; i++) {
                count++;
                //Console.WriteLine("Count {0} {1} bags", b.Item2, b.Item1.Colour);
                countInnerBags(b.Item1, ref count);
            }
             
        }
    }

}
