import UIKit

let target = 2020

let input = [
    1757,
    1890,
    1750,
    1440,
    1822,
    1957,
    2005,
    1979,
    1405,
    2003,
    1997,
    1741,
    1494,
    1780,
    1774,
    1813,
    447,
    1429,
    1990,
    1767,
    1969,
    1787,
    1944,
    1863,
    1778,
    2004,
    1991,
    1754,
    1748,
    1756,
    1977,
    611,
    1934,
    1818,
    1924,
    528,
    1753,
    1867,
    1865,
    1799,
    1743,
    1955,
    1993,
    1972,
    1987,
    1960,
    1817,
    1837,
    1900,
    1839,
    1946,
    1786,
    1857,
    1840,
    1985,
    1850,
    1801,
    1926,
    1523,
    1886,
    1492,
    1737,
    1909,
    1766,
    1986,
    1773,
    1749,
    1781,
    1760,
    1849,
    1833,
    1854,
    1814,
    1820,
    2000,
    1834,
    1851,
    1779,
    1825,
    1885,
    1882,
    1912,
    962,
    1988,
    302,
    1965,
    1751,
    1764,
    1844,
    1949,
    1984,
    1933,
    958,
    1746,
    1999,
    1914,
    1989,
    1879,
    1954,
    1827,
    1816,
    1918,
    633,
    1797,
    1811,
    1936,
    1961,
    1937,
    1829,
    1788,
    1772,
    1505,
    1905,
    1304,
    1404,
    1868,
    1978,
    1872,
    2006,
    1256,
    1883,
    1966,
    1931,
    1796,
    1793,
    714,
    1904,
    1841,
    1824,
    1962,
    1739,
    1897,
    1906,
    1735,
    1876,
    873,
    1959,
    1963,
    1917,
    1804,
    1789,
    1782,
    1848,
    1828,
    1826,
    1929,
    1525,
    1862,
    1952,
    1878,
    1775,
    1776,
    1430,
    1943,
    1938,
    1941,
    1594,
    1928,
    1856,
    1903,
    1871,
    1836,
    1847,
    1956,
    1915,
    1870,
    1875,
    1892,
    276,
    1896,
    1945,
    1821,
    1947,
    1898,
    1802,
    1853,
    1895,
    1790,
    1819,
    1980,
    1832,
    1673,
    1964,
    1800,
    1971,
    1842,
    2002,
    1921,
    1940,
    1845,
    1527,
    1428,
    1932,
    1893,
    1908,
    1889,
    1974,
    1981,
    1791,
    1975
]


class ValueFinder {
    let inputs: [Int]
    let target: Int

    init(inputs: [Int], target: Int) {
        self.inputs = inputs
        self.target = target
    }

    func findValuePair() -> (valueOne: Int, valueTwo: Int)? {
        let sortedInputs = inputs.sorted()
        var leftIndex = 0
        var rightIndex = sortedInputs.count - 1

        while leftIndex < rightIndex {
            let leftElement = sortedInputs[leftIndex]
            let rightElement = sortedInputs[rightIndex]
            if leftElement + rightElement > target {
                rightIndex = rightIndex - 1
            } else if leftElement + rightElement < target {
                leftIndex = leftIndex + 1
            } else {
                // We found our match
                return (leftElement, rightElement)
            }
        }

//        let minimumAddends = inputs.filter { $0 <= halfway }
//
//        for value in minimumAddends {
//            let targetAddend = target - value
//            guard inputs.contains(targetAddend) else { continue }
//
//            return (value, targetAddend)
//        }

        return nil
    }

    func findValueTriad() -> (valueOne: Int, valueTwo: Int, valueThree: Int)? {
        let sortedInputs = inputs.sorted()

        for i in (0 ..< (sortedInputs.count - 1)) {
            var centerIndex = i + 1
            var rightIndex = sortedInputs.count - 1

            while (centerIndex < rightIndex) {
                let leftmostElement = sortedInputs[i]
                let centerElement = sortedInputs[centerIndex]
                let rightElement = sortedInputs[rightIndex]

                let currentSum = leftmostElement + centerElement + rightElement
                if currentSum > target {
                    rightIndex = rightIndex - 1
                } else if currentSum < target {
                    centerIndex = centerIndex + 1
                } else {
                    // We found a match
                    return (leftmostElement, centerElement, rightElement)
                }
            }
        }

        return nil
    }
}

let valueFinder = ValueFinder(inputs: input, target: target)
if let result = valueFinder.findValuePair() {
    let solution = result.0 * result.1
}

if let threeSumResult = valueFinder.findValueTriad() {
    let solution = threeSumResult.valueOne * threeSumResult.valueTwo * threeSumResult.valueThree
} else {
    print("unable to find three numbers that add to 2020")
}
