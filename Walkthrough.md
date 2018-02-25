### Step 1 - Organise nouns and verbs of user stories into Objects and Messages
             Objects  | Messages
-------------         |     -------------
Air traffic controller|
Plane                 |
Airport               | instruct_landing, instruct_take_off, plane_count
Weather               |  stormy?

### Step 2 - Feature test in ```pry```
```NameError: uninitialized constant Airport
from (pry):1:in \__pry__'
```

**Need to define an** ```Airport``` **class**.

### Step 3 - From feature test to unit test (using RSpec)
- Following a TDD approach, before creating an ```Airport``` class, I wrote a failing unit test
in file ```airport_spec.rb```:
```Describe Airport do
end
```

- After running RSpec, I got the following error:
```An error occurred while loading ./spec/airport_spec.rb.
Failure/Error:
  describe Airport do

  end

NameError:
  uninitialized constant Airport
# ./spec/airport_spec.rb:1:in `<top (required)>'
```

-The test does not know what ```Airport``` is, therefore we need to create an ```Airport``` class.

### Step 4 - Define an ```Airport``` class
_Classes and modules are going to be defined in folder_ ```lib```

- Created an ```Airport``` class in ```lib``` folder. In order for the RSpec to pass, we need to add a ```require```
function to link ```spec/airport_spec.rb``` and ```lib/airport.rb```

- Test passes!

- Commit

### Step 4 - Run feature test to assess expected ```Airport``` class behaviour
- ```[4] pry(main)> plane = airport.instruct_landing
NoMethodError: undefined method `instruct_landing' for #<Airport:0x00007f820a174d58>
from (pry):4:in `__pry__'
```
Error tells us that there is no method called ```instruct_landing```.

### Step 5 - Test drive code by unit tests
- In ```spec/airport_spec.rb```, I created a unit test for ```instruct_landing```
```it { is expected_to respond_to :instruct_landing}
```
- After running RSpec, I got the following error:
```
Airport
should respond to #instruct_landing (FAILED - 1)

Have you considered running rubocop? It will help you improve your code!
Try it now! Just run: rubocop

Failures:

  1) Airport should respond to #instruct_landing
     Failure/Error: it { is_expected.to respond_to :instruct_landing }
       expected #<Airport:0x00007ff40fa88b70> to respond to :instruct_landing
     # ./spec/airport_spec.rb:4:in `block (2 levels) in <top (required)>'

Finished in 0.07628 seconds (files took 0.28992 seconds to load)
1 example, 1 failure
```
- In order for the test to pass, I updated ```Airport``` class defining the ```instruct_landing``` method:
```
class Airport
  def instruct_take_off

  end
end
```
- Test passes!
- Commit

### Step 8 - Build a plane
- In ```spec``` folder, I created a ```plane_spec.rb``` file to test for a ```Plane``` class.
- Ran RSpec and got the following errors:
```
NameError:
  uninitialized constant Plane
# ./spec/plane_spec.rb:1:in `<top (required)>'
```
- Therefore, I created a ```lib/plane.rb``` and defined an empty ```Plane```:
```
class Plane

end
```
- Unit test passes!

### Step 9 - Create class for weather and corresponding unit test
- Same approach as **Step 8**

- Commit

### Step 10 - Make the airport instruct a plane to land
- Wrote a unit test in RSpec for the method ```instruct_landing```
- Similarly to step 14 in ```boris-bikes``` challenge, in ```Airport``` class, I set up an initial attribute ```@planes = []``` using ```initialize```.
- Used ```attr_reader``` to read ```@planes = []```
- I updated ```instruct_landing``` method and passed an argument ```plane``` to it. Through the ```<<``` operator, ```plane``` is going to be added to the ```@planes``` array.
- **Airport now instructs plane to land**
- Commit

### Step 10.5 - Change test for ```instruct_landing```
- Replace ```receive``` with ```respond_to(:instruct_landing).with(1).argument``` following example from ```boris-bikes```
- Commit

### Step 11 - Make the airport instruct a plane to take off
- Ran feature test in ```pry``` and got the following error:
```NoMethodError: undefined method `instruct_take_off' for #<Airport:0x00007fd5912dd548 @planes=[]>
```
- Wrote a unit test in RSpec for ```instruct_take_off```. Test gives the following error:
``` Failure/Error: expect(airport).to respond_to(:instruct_take_off)
       expected #<Airport:0x00007fa0290b2ea0 @planes=[]> to respond to :instruct_take_off
```
- Defined ```instruct_take_off``` in ```Airport``` class, which makes the RSpec test pass. However, the feature test in ```pry``` still fails, giving the following error:
```ArgumentError: wrong number of arguments (given 1, expected 0)
from /Users/WorkStuff/Desktop/gitDir/airport_challenge/lib/airport.rb:12:in `instruct_take_off'
```
- To fix this error, I changed the unit test to take one argument and also passed one argument to ```instruct_take_off``` method.
- Tests are passing now.
- **Airport now instructs plane to take off**
- Commit

### Step 12 - Prevent landing when airport is full
- Ran feature test in ```pry```, at this stage an infinite number of planes can land to the airport.
- Wrote unit test that raises an error once 20 or more planes are landed.
- In ```Airport``` class, I set up another attribute ```@capacity``` that, for the moment, uses a _magic number_.
- Feature and unit tests pass
- **Landing is now prevented when airport is full**
- Commit

### Step 13 - A bit of refactoring
- Got rid of the _magic number_ by passing ```capacity``` to ```initialize``` in ```Airport``` class
- Commit

### Step 14 - More refactoring (inspired by [Sam's tutorial](https://www.youtube.com/watch?v=Vg0cFVLH_EM))
- To make the code more readable, I defined a new ```private``` method ```full?```. The method is private because it won't be called from outside the class.
- Further refactoring in ```airport_spec.rb```

### Step 14 - Prevent landing and take off when weather is stormy
- Wrote unit test to prevent landing and take off when weather is stormy.
- Used new RSPec syntax: ```context``` to group tests that are related logically
- Defined a new ```private``` method called ```stormy?``` that generates random output.
  **At some point, the** ```stormy?``` **method** **will have to be placed in** ```Weather``` **Single Responsibility Principle**
- Test passes
- **Landing and take off are now prevented when weather is stormy**
- Commit

### Step 15 - Take stormy? method to another class (Single Responsibility Principle)
- Wrote unit test in ```weather_spec.rb``` for both "stormy" and "not stormy" conditions, following both [code review rubric](docs/review.md) and [Sam's tutorial](https://www.youtube.com/watch?v=Vg0cFVLH_EM)].
- Ran RSpec and got following error:
```NoMethodError:
       undefined method `stormy?' for #<Weather:0x00007f822a98d128>
```
- In class ```Weather```, I defined method ```stormy?``` and private array of default values ```OUTLOOKS``` along with private method ```random_outlook```, which randomly selects one of the four items in the array (see [code review rubric](docs/review.md)).
- As per instructions, I used a stub to override random weather (see [code review rubric](docs/review.md)).
- ```Airport``` class does not depend on ```Weather``` class anymore.
- Commit

### Step 16 - Plane can only take off from airport it is in (edge case)
- Feature test in ```pry``` shows that same plane can take off from any airport
- ```
[37] pry(main)> airport
=> #<Airport:0x00007ff112a50090 @capacity=21, @planes=[#<Plane:0x00007ff112b190d0>], @weather=#<Weather:0x00007ff112a500b8>>
[38] pry(main)> airport_2
=> #<Airport:0x00007ff112af1d78
 @capacity=20,
 @planes=[#<Plane:0x00007ff112b190d0>, #<Plane:0x00007ff112b190d0>],
 @weather=#<Weather:0x00007ff112af1da0>>
[39] pry(main)> airport_2.instruct_take_off(plane)
RuntimeError: Cannot take off due to stormy weather
from /Users/WorkStuff/Desktop/gitDir/airport_challenge/lib/airport.rb:20:in `instruct_take_off'
[40] pry(main)> airport.instruct_take_off(plane)
RuntimeError: Cannot take off due to stormy weather
from /Users/WorkStuff/Desktop/gitDir/airport_challenge/lib/airport.rb:20:in `instruct_take_off'
[41] pry(main)> airport.instruct_take_off(plane)
=> nil
```
- Wrote test in ```#instruct_take_off``` in ```airport_spec.rb``` to raise error if plane is not at specific airport, ran rspec and got the following error:
```Failure/Error: expect { airport.instruct_take_off(plane) }.to raise_error 'Plane cannot take off. Plane at another airport'
       expected Exception with "Plane cannot take off. Plane at another airport" but nothing was raised
```
- Updated the ```instruct_take_off``` method and refactored it based on Sam's tutorial
- **A plane can now only take off from the airport it is in**
- Commit