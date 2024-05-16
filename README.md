The Chicken Simulation Project

Name: Orin McDonogh

Student Number: C20307673

Class Group: TU856

## Description
This project simulates a chicken's behavior in a dynamic environment. The chickens can walk around, search for food, and mate to produce offspring. The simulation includes interactive UI elements to control various parameters, enhancing the simulation experience.

## Video:

https://www.youtube.com/watch?v=J2kHSSFA4NU

## Screenshots
![alt text](image-1.png)
![alt text](image-2.png)

## Instructions
Open the project in Godot.
Run the MainWorld scene to start the simulation.
Use the sliders in the UI to adjust the food spawn rate and hunger timer.

# How it works
The simulation consists of multiple chickens that exhibit natural behaviors such as walking, searching for food, and mating. The environment includes randomly spawning food objects, which the chickens can find and consume to reduce their hunger levels. When two chickens are close enough and meet certain conditions, they can mate and produce a new chicken.

The project uses various classes and scenes to organize the behaviors and interactions:

Chicken: Handles movement, animations, and interactions such as mating.
Food: Spawns randomly in the environment and can be consumed by chickens.
MainWorld: Manages the overall simulation, including spawning food and chickens.

# List of classes/assets

| Class/asset | Source |
|-----------|-----------|
| MyClass.cs | Self written |
| MyClass1.cs | Modified from [reference]() |
| MyClass2.cs | From [reference]() |

Each team member or individual needs to write a paragraph or two explaining what they contributed to the project

- What they did
- What they are most proud of
- What they learned

# References
* Item 1
* Item 2

# From here on, are examples of how to different things in Markdown. You can delete.  

## This is how to markdown text:

This is *emphasis*

This is a bulleted list

- Item
- Item

This is a numbered list

1. Item
1. Item

This is a [hyperlink](http://bryanduggan.org)

# Headings
## Headings
#### Headings
##### Headings

This is code:

```Java
public void render()
{
	ui.noFill();
	ui.stroke(255);
	ui.rect(x, y, width, height);
	ui.textAlign(PApplet.CENTER, PApplet.CENTER);
	ui.text(text, x + width * 0.5f, y + height * 0.5f);
}
```

So is this without specifying the language:

```
public void render()
{
	ui.noFill();
	ui.stroke(255);
	ui.rect(x, y, width, height);
	ui.textAlign(PApplet.CENTER, PApplet.CENTER);
	ui.text(text, x + width * 0.5f, y + height * 0.5f);
}
```

This is an image using a relative URL:

![An image](images/p8.png)

This is an image using an absolute URL:

![A different image](https://bryanduggandotorg.files.wordpress.com/2019/02/infinite-forms-00045.png?w=595&h=&zoom=2)

This is a youtube video:

[![YouTube](http://img.youtube.com/vi/J2kHSSFA4NU/0.jpg)](https://www.youtube.com/watch?v=J2kHSSFA4NU)

This is a table:

| Heading 1 | Heading 2 |
|-----------|-----------|
|Some stuff | Some more stuff in this column |
|Some stuff | Some more stuff in this column |
|Some stuff | Some more stuff in this column |
|Some stuff | Some more stuff in this column |

"# ChickenSimulation" 
