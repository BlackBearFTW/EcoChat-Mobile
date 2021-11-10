interface MarkerStructureInterface {
    location: {
        latitude: number,
        longitude: number
    },
    sensorStatus: MarkerStatusStructureInterface
    roofed: boolean
}

interface MarkerStatusStructureInterface {
    batteryLevel: number,
    usbSlots: {
        total: number,
        available: number
    },
}

export default MarkerStructureInterface